#!/bin/bash

function set_osx_preferences(){
	run "set computer name"
	sudo scutil --set ComputerName "Domenico Gemoli's Macbook Pro"
  	sudo scutil --set HostName "macbook-dgemoli"
  	sudo scutil --set LocalHostName "macbook-dgemoli"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "macbook-dgemoli"

	run "hide the Time Machine and Volume icons from menu bar"
	for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
		defaults write "${domain}" dontAutoLoad -array \
			"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
			"/System/Library/CoreServices/Menu Extras/Volume.menu"
	done
	defaults write com.apple.systemuiserver menuExtras -array \
		"/System/Library/CoreServices/Menu Extras/Clock.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu"

	run "expand save panel by default"
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
	defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

	run "expand print panel by default"
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
	defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

	run "save to disk (not to iCloud) by default"
	defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

	run "Remove duplicates in the “Open With” menu"
	/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

	run "Disable smart quotes and dashes"
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

	run "enable tap to click for this user and for the login screen"
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
	defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

	run "set natural scroll direction"
	defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

	run "enable full keyboard access for all controls"
	defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

	run "use scroll gesture with the Ctrl (^) modifier key to zoom"
	defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
	defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

	run "disable press-and-hold for keys in favor of key repeat"
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

	run "disable auto-correct"
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

	run "set keyboard repeat rate"
	defaults write NSGlobalDomain KeyRepeat -int 2

	run "set a shorter Delay until key repeat"
	defaults write NSGlobalDomain InitialKeyRepeat -int 25

	run "disable autocorrect"
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

	run "require password immediately after sleep or screen saver begins"
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 0

	run "save screenshots to the desktop"
	defaults write com.apple.screencapture location -string "${HOME}/Desktop"

	run "save screenshots in PNG format"
	defaults write com.apple.screencapture type -string "png"

	run "disable shadow in screenshots"
	defaults write com.apple.screencapture disable-shadow -bool true

	run "show Full Path in Finder Title"
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	run "show all filename extensions"
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	run "show status bar"
	defaults write com.apple.finder ShowStatusBar -bool true

	run "show path bar"
	defaults write com.apple.finder ShowPathbar -bool true

	run "avoid creating .DS_Store files on network volumes"
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

	run "disable disk image verification"
	defaults write com.apple.frameworks.diskimages skip-verify -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
	defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

	run "use column view in all Finder windows by default"
	defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

	run "show the ~/Library folder"
	chflags nohidden ~/Library

	run "change minimize/maximize window effect"
	defaults write com.apple.dock mineffect -string "genie"

	run "minimize windows into their application’s icon"
	defaults write com.apple.dock minimize-to-application -bool false

	run "show indicator lights for open applications in the Dock"
	defaults write com.apple.dock show-process-indicators -bool true

	run "disable Dashboard"
	defaults write com.apple.dashboard mcx-disabled -bool true

	run "automatically hide and show the Dock"
	defaults write com.apple.dock autohide -bool false

	run "make Dock icons of hidden applications translucent"
	defaults write com.apple.dock showhidden -bool true

	run "privacy: don’t send search queries to Apple"
	defaults write com.apple.Safari UniversalSearchEnabled -bool false
	defaults write com.apple.Safari SuppressSearchSuggestions -bool true

	run "press Tab to highlight each item on a web page"
	defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

	run "set Safari’s home page to about:blank for faster loading"
	defaults write com.apple.Safari HomePage -string "about:blank"

	run "prevent Safari from opening ‘safe’ files automatically after downloading"
	defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

	run "disable Safari’s thumbnail cache for History and Top Sites"
	defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

	run "enable Safari’s debug menu"
	defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

	run "enable the Develop menu and the Web Inspector in Safari"
	defaults write com.apple.Safari IncludeDevelopMenu -bool true
	defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
	defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

	run "add a context menu item for showing the Web Inspector in web views"
	defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

	run "only use UTF-8 in Terminal.app"
	defaults write com.apple.terminal StringEncodings -array 4

	run "prevent Photos from opening automatically when devices are plugged in"
	defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

	run "prevent Time Machine from Prompting to Use New Hard Drives as Backup Volume"
	defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

	run "show hidden files"
	defaults write com.apple.finder AppleShowAllFiles YES

	run "VSCode as default text editor"
	defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add \
		'{LSHandlerContentType=public.plain-text;LSHandlerRoleAll=com.microsoft.VSCode;LSHandlerPreferredVersions={LSHandlerRoleAll=-;};}'
}
