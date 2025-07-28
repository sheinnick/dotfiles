# macos settings https://macos-defaults.com/
# https://github.com/KELiON/dotfiles/blob/master/osx/set-defaults.sh
# https://gist.github.com/g3d/2709563#os-x-preferences
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos

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


########################
###### finder
###########

# finder warp speed
defaults write com.apple.finder DisableAllAnimations -bool true

# Keep folders on top when sorting by name:
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Finder: allow text selection in Quick Look.
defaults write com.apple.finder QLEnableTextSelection -bool true

#Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Display file extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

########################
###### dock
###########

# make dock faster
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
defaults write com.apple.dock mineffect -string "scale"

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

########################
###### touchpad
###########

#  Click weight (threshold)
defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "0"

# Enable tap to click for trackpad
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


########################
###### other
###########

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

killall Dock

#hide weekday in menubar
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool false

# show cmd+tab window on all displays
defaults write http://com.apple.dock appswitcher-all-displays -bool true
killall Dock

# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable full keyboard access for all controls (Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Show battery percent"
defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1