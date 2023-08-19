#!/bin/bash

# Check if Homebrew is installed
if [ ! -f "`which brew`" ]; then
  echo 'Installing homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  echo 'Updating homebrew'
  brew update
fi


# zsh
if [ ! -f "`which zsh`" ]; then
  echo 'Installing zsh'
  brew install zsh
else
  echo 'zsh is on the board'
fi

# Check if oh-my-zsh is installed
OMZDIR="$HOME/.oh-my-zsh"
if [ ! -d "$OMZDIR" ]; then
  echo 'Installing oh-my-zsh'
  /bin/sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
else
  echo 'Updating oh-my-zsh'
  upgrade_oh_my_zsh
fi

# Check if Mac-CLI is installed
if [ ! -f "which mac" ]; then
    echo 'Installing Mac-CLI'
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/install)"
else
    echo 'Updating Mac-CLI'
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/guarinogabriel/mac-cli/master/mac-cli/tools/update)"
fi

# Change default shell
if [! $0 = "-zsh"]; then
  echo 'Changing default shell to zsh'
  chsh -s /bin/zsh
else
  echo 'Already using zsh'
fi

# install powerline fonts
echo 'install powerline fonts'
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts

brew install python3
pip3 install virtualenv
pip3 install virtualenvwrapper

# macos settings https://macos-defaults.com/

#Enable repeat symbols
defaults write -g ApplePressAndHoldEnabled -bool false

#Show hidden files
defaults write com.apple.finder AppleShowAllFiles YES; killall Finder

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# dock
# make dock faster
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
#autohide
defaults write com.apple.dock autohide -bool true
# left
defaults write com.apple.dock "orientation" -string "left"

defaults write com.apple.dock "tilesize" -int "22"
defaults write com.apple.dock "show-recents" -bool "false"

#  Click weight (threshold)
defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "0"

# show cmd+tab window on all displays
defaults write http://com.apple.dock appswitcher-all-displays -bool true
killall Dock

# Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable auto-capitalization and double-space period"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -int 0

# Enable tap to click for trackpad
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable full keyboard access for all controls (Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Show battery percent"
defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true

# Display file extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
