#!/bin/bash
# Opinionated macOS security audit + hardening script.
# Writes a log file next to this script and prints to terminal.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$SCRIPT_DIR/macos_check_security.log"
# Mirror stdout/stderr to both terminal and the log for an audit trail.
exec > >(tee "$LOG") 2>&1

# Colors for readable status output
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

set -u
# Always show where the log is on exit and wait for Enter (useful when run from Finder).
trap 'echo; echo "[!] script ended. log: $LOG"; read -p "Press Enter to exit..."' EXIT

ok(){ echo "${GREEN}[OK]${RESET}  $*"; }
fix(){ echo "${YELLOW}[FX]${RESET}  $*"; }
err(){ echo "${RED}[ERR]${RESET} $*"; }
line(){ printf '%*s\n' "${COLUMNS:-80}" '' | tr ' ' '-'; }

# --- helpers ---
# Helper getters to query current security posture.
# Each function normalizes output for simple comparisons and clear summaries.

# SIP (System Integrity Protection) state: core system protection; should be enabled.
get_sip(){ csrutil status 2>/dev/null | grep -qi enabled && echo enabled || echo disabled; }

# Gatekeeper (spctl) state: only allow trusted code; protects against unverified apps.
get_spctl(){ spctl --status 2>/dev/null | grep -qi enabled && echo enabled || echo disabled; }

# Application Firewall global state: block unwanted inbound connections.
get_fw_state(){ /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep -q 1 && echo on || echo off; }

# Firewall stealth mode: drop unsolicited probes; reduces fingerprinting.
get_fw_stealth(){ /usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode | grep -q 1 && echo on || echo off; }

# Remote Login (SSH) state: should be off unless required.
get_ssh(){ systemsetup -getremotelogin 2>/dev/null | awk '{print tolower($NF)}'; }

# Automatic software update schedule: keep the system patched.
get_updatesched(){ softwareupdate --schedule 2>/dev/null | grep -qi "on" && echo on || echo off; }

# FileVault disk encryption status (raw and normalized).
get_fv_raw(){ fdesetup status 2>/dev/null || true; }
get_fv(){ get_fv_raw | grep -qi "filevault is on" && echo on || echo off; }

# Number of configured file shares: fewer is safer.
get_shares_count(){ sharing -l 2>/dev/null | awk -F': *' '/^name:/{c++} END{print c+0}'; }

# SMB guest access: should be disabled to avoid anonymous access.
get_guest_smb(){ defaults read /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess 2>/dev/null | grep -q 1 && echo on || echo off; }

# Automatic login: should be off to require credentials at login.
get_autologin(){ defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser >/dev/null 2>&1 && echo on || echo off; }

# --- sudo check ---
# Re-exec with sudo if not root. Most operations require elevated privileges.
if [[ $EUID -ne 0 ]]; then
  echo "[!] need sudo. re-running..."
  exec sudo "$0" "$@"
fi

# --- PRE ---
# Capture baseline (before) values. Used to decide changes and display summary.
echo; line; echo " pre-checks "; line
B_SIP=$(get_sip)
B_SPCTL=$(get_spctl)
B_FW=$(get_fw_state)
B_STEALTH=$(get_fw_stealth)
B_SSH=$(get_ssh)
B_UPD=$(get_updatesched)
B_FV=$(get_fv)
B_FV_RAW="$(get_fv_raw)"
B_SHARES=$(get_shares_count)
B_GUEST_SMB=$(get_guest_smb)
B_AUTOLOGIN=$(get_autologin)

echo "sip: $B_SIP"
echo "gatekeeper: $B_SPCTL"
echo "firewall: $B_FW, stealth: $B_STEALTH"
echo "ssh: $B_SSH"
echo "auto-updates: $B_UPD"
echo "filevault: $B_FV"
printf '%s\n' "  ${B_FV_RAW//$'\n'/$'\n'  }"
echo "shares: $B_SHARES"
echo "smb guest: $B_GUEST_SMB"
echo "autologin: $B_AUTOLOGIN"
line

# --- FIXES ---
# Apply safe hardening steps:
# - Enable Gatekeeper, Firewall, and Stealth mode.
# - Remove broad inbound allowances for common services.
# - Disable SSH and guest file sharing unless explicitly needed.
# - Remove configured shares.
# - Disable auto login; enable auto updates.
# - For FileVault and SIP, print guidance (they require manual/Recovery actions).
if [[ "$B_SPCTL" != "enabled" ]]; then
  if spctl --master-enable; then
    fix "enabled gatekeeper"
  else
    err "failed to enable gatekeeper"
  fi
else
  ok "gatekeeper ok"
fi

if [[ "$B_FW" != "on" ]]; then
  if /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on; then
    fix "firewall on"
  else
    err "failed to enable firewall"
  fi
else
  ok "firewall ok"
fi

if [[ "$B_STEALTH" != "on" ]]; then
  if /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on; then
    fix "stealth on"
  else
    err "failed to enable stealth mode"
  fi
else
  ok "stealth ok"
fi

# Remove any existing inbound app allowances for common sharing/remote services.
for app in /usr/sbin/smbd /usr/libexec/sharingd /usr/libexec/sshd-keygen-wrapper /usr/sbin/cupsd; do
  /usr/libexec/ApplicationFirewall/socketfilterfw --remove "$app" >/dev/null 2>&1 && fix "removed inbound: $app" || true
done

# Turn off Remote Login (SSH) unless explicitly required.
if [[ "$B_SSH" != "off" ]]; then
  if systemsetup -f -setremotelogin off; then
    fix "ssh off"
  else
    err "failed to disable ssh"
  fi
else
  ok "ssh ok"
fi

# Disable SMB daemon and guest access for SMB/AFP.
launchctl disable system/com.apple.smbd >/dev/null 2>&1 && fix "disabled smbd" || true
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false && fix "SMB guest off" || true
defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false && fix "AFP guest off" || true

# Remove all configured file shares (can be recreated if needed).
mapfile -t shares < <(sharing -l 2>/dev/null | awk -F': *' '/^name:/{print $2}')
for s in "${shares[@]:-}"; do
  sharing -r "$s" >/dev/null 2>&1 && fix "removed share: $s" || true
done

# Ensure automatic login is disabled.
if [[ "$B_AUTOLOGIN" == "on" ]]; then
  if defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser >/dev/null 2>&1; then
    fix "autologin off"
  else
    err "failed to disable autologin"
  fi
else
  ok "autologin ok"
fi
# Ensure automatic updates are scheduled.
if [[ "$B_UPD" != "on" ]]; then
  if softwareupdate --schedule on; then
    fix "auto-updates on"
  else
    err "failed to enable auto-updates"
  fi
else
  ok "auto-updates ok"
fi

# Do not auto-enable FileVault/SIP; provide guidance instead.
if [[ "$B_FV" != "on" ]]; then
  err "filevault off → run 'fdesetup enable' manually"
else
  ok "filevault on"
fi

if [[ "$B_SIP" != "enabled" ]]; then
  err "sip disabled → enable via recovery"
else
  ok "sip enabled"
fi

# --- AFTER ---
# Show a concise before → after summary of all relevant settings.
echo; line; echo " summary before → after "; line
printf "%-15s %-8s -> %-8s\n" "sip"          "$B_SIP"      "$(get_sip)"
printf "%-15s %-8s -> %-8s\n" "gatekeeper"   "$B_SPCTL"    "$(get_spctl)"
printf "%-15s %-8s -> %-8s\n" "firewall"     "$B_FW"       "$(get_fw_state)"
printf "%-15s %-8s -> %-8s\n" "stealth"      "$B_STEALTH"  "$(get_fw_stealth)"
printf "%-15s %-8s -> %-8s\n" "ssh"          "$B_SSH"      "$(get_ssh)"
printf "%-15s %-8s -> %-8s\n" "auto-updates" "$B_UPD"      "$(get_updatesched)"
printf "%-15s %-8s -> %-8s\n" "filevault"    "$B_FV"       "$(get_fv)"
printf "%-15s %-8s -> %-8s\n" "shares"       "$B_SHARES"   "$(get_shares_count)"
printf "%-15s %-8s -> %-8s\n" "smb guest"    "$B_GUEST_SMB" "$(get_guest_smb)"
printf "%-15s %-8s -> %-8s\n" "autologin"    "$B_AUTOLOGIN" "$(get_autologin)"