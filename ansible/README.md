# macOS setup with Ansible

This folder contains playbooks and roles to bootstrap and harden macOS using Homebrew and system settings.

## main run  
``` bash
ansible-galaxy install -r requirements.yml
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_all.yml --skip-tags work
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_secutiry.yml
```

## How it works

- Playbooks:
  - `playbook_macos_apps.yml`: full setup (brew taps, fonts, CLI tools, cask apps, a few defaults, start `skhd`).
  - `playbook_macos_security.yml`: security-hardening only (Gatekeeper, Firewall, SSH, SMB/AFP, updates, privacy, etc.).
- Roles and variables:
  - `roles/macos_apps/` installs taps, fonts, CLI and cask apps as defined in `roles/macos_apps/defaults/main.yml`.
  - `roles/macos_security/` enforces secure settings using idempotent commands and `osx_defaults`.
  - Per-host overrides: `host_vars/localhost.yml`.
- Collections: `requirements.yml` installs `geerlingguy.mac` and `community.general`.

## Prerequisites

Install Homebrew and Ansible. From the repo root you can run:

```bash
00_install_brew_and_other_before_ansible.sh
```

## Install collections

```bash
cd ansible
ansible-galaxy install -r requirements.yml
```

## Run playbooks

```bash
# Full local setup
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_apps.yml

# Security-hardening only
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_security.yml
```

## Discover available tags

```bash
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_apps.yml --list-tags
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_security.yml --list-tags
```

### Common tags

- From `roles/macos_apps` tasks: `homebrew`, `tap`, `cask`, `fonts`, `cli`, `useful`, `my`, `work`, `macos`
- From `roles/macos_security` tasks: `macos_security`, `gatekeeper`, `firewall`, `ssh`, `smb`, `afp`, `sharing`, `login`, `updates`, `privacy`, `screensaver`, `filevault`, `sip`

## Examples: run by tags

```bash
# Install only fonts (macOS all)
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_apps.yml \
  --tags fonts

# Install only “useful” cask apps (macOS all)
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_apps.yml \
  --tags useful

# Install only CLI apps (macOS all)
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_apps.yml \
  --tags cli

# Do everything except work apps (macOS all)
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_apps.yml \
  --skip-tags work

# Security: enable/verify Gatekeeper only
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_security.yml \
  --tags gatekeeper

# Security: firewall + SSH hardening only
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_security.yml \
  --tags firewall,ssh

# Security: everything except privacy-related toggles
ansible-playbook --connection=local --inventory 127.0.0.1, playbook_macos_security.yml \
  --skip-tags privacy
```

## Customize

- Edit `roles/macos_apps/defaults/main.yml` to add/remove taps, fonts, CLI or cask apps.
- Place host-specific overrides in `host_vars/localhost.yml`.

## Useful flags

- `--list-tags`, `--list-tasks`
- `--check` for dry-run (some commands use `check_mode: no`)
- `-K` for privilege escalation when prompted


