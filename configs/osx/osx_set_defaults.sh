#!/usr/bin/env bash

# macOS settings https://macos-defaults.com/
# https://github.com/KELiON/dotfiles/blob/master/osx/set-defaults.sh
# https://gist.github.com/g3d/2709563#os-x-preferences
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos

########################
###### preflight
###########

# Close System Settings/Preferences so they don't override changes while writing defaults
osascript -e 'tell application "System Settings" to quit' >/dev/null 2>&1 || true
osascript -e 'tell application "System Preferences" to quit' >/dev/null 2>&1 || true

# Clear preferences cache to avoid stale values being written back
killall cfprefsd >/dev/null 2>&1 || true

########################
###### keyboard
###########

#Enable repeat symbols
defaults write -g ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-capitalization and double-space period"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0

# Enable full keyboard access for all controls (Tab moves focus to all controls)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3


########################
###### finder
###########

# finder warp speed
defaults write com.apple.finder DisableAllAnimations -bool true

# Keep folders on top when sorting by name:
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: allow text selection in Quick Look.
defaults write com.apple.finder QLEnableTextSelection -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Always open everything in Finder's list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
## System-wide (for all users):
sudo defaults write /Library/Preferences/com.apple.desktopservices DSDontWriteNetworkStores -bool true
sudo defaults write /Library/Preferences/com.apple.desktopservices DSDontWriteUSBStores -bool true

# Display file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Apply Finder changes
killall Finder

########################
###### dock
###########

# make dock faster
# Remove delay before Dock shows on hover
defaults write com.apple.dock autohide-delay -float 0

# Remove animation duration when showing/hiding Dock
defaults write com.apple.dock autohide-time-modifier -int 0

# Use scale effect when minimizing windows
defaults write com.apple.dock mineffect -string "scale"

# Disable window opening/closing animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable the "suck" animation when minimizing windows
defaults write com.apple.dock minimize-to-application -bool true

# Speed up Launchpad (SpringBoard) animations
defaults write com.apple.dock springboard-show-duration -int 0
defaults write com.apple.dock springboard-hide-duration -int 0
defaults write com.apple.dock springboard-page-duration -int 0

#autohide
defaults write com.apple.dock autohide -bool true

# left
defaults write com.apple.dock "orientation" -string "left"

# small
defaults write com.apple.dock "tilesize" -int "22"

#hide recents
defaults write com.apple.dock "show-recents" -bool "false"

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

## Hot corners (require Dock)
# top-left → Desktop + ⌘
defaults write com.apple.dock wvous-tl-corner -int 4
defaults write com.apple.dock wvous-tl-modifier -int 1048576

# top-right → Mission Control + ⌘
defaults write com.apple.dock wvous-tr-corner -int 2
defaults write com.apple.dock wvous-tr-modifier -int 1048576

# bottom-left → Launchpad + ⌘
defaults write com.apple.dock wvous-bl-corner -int 11
defaults write com.apple.dock wvous-bl-modifier -int 1048576

# bottom-right → Application Windows + ⌘
defaults write com.apple.dock wvous-br-corner -int 3
defaults write com.apple.dock wvous-br-modifier -int 1048576

# Show Cmd+Tab app switcher on all displays
defaults write com.apple.dock appswitcher-all-displays -bool true

# Apply Dock changes
killall Dock

########################
###### touchpad
###########

# Click weight (threshold)
defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "0"

# Enable tap to click for trackpad
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


########################
###### other
###########

#hide weekday in menubar
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool false

# Show battery percentage in the menu bar and Control Center
# Note: may require signing out/in or restarting Control Center
defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write com.apple.controlcenter.plist BatteryShowPercentage -bool true

# Don't restore windows when quitting and re-opening apps
defaults write -g NSQuitAlwaysKeepsWindows -bool false

# Don't restore apps after rebooting
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

########################
###### security
###########

# Enable automatic OS and App Store updates
## System updates:
sudo softwareupdate --schedule on
sudo defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults write com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true

## Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

## App Store apps:
sudo defaults write com.apple.commerce AutoUpdate -bool true

# Privacy/telemetry
## Disable diagnostics sharing (per‑user)
defaults write com.apple.SubmitDiagInfo AutoSubmit -bool false
defaults write com.apple.SubmitDiagInfo ThirdPartyDataSubmit -bool false
## Ad personalization off (per‑user)
defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false
defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false

# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


########################
###### refresh ui
###########

# Refresh menu bar and system UI so changes like clock/battery appear immediately
killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true
killall SystemUIServer >/dev/null 2>&1 || true
killall ControlCenter >/dev/null 2>&1 || true
killall NotificationCenter >/dev/null 2>&1 || true

# Reload Quick Look generators (affects Finder previews and text selection in Quick Look)
qlmanage -r >/dev/null 2>&1 || true