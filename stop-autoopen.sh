# RUN SCRIPT ON MACHINES TO PREVENT 'Reopen windows when logging back in'.
# This effectively disables the “reopen windows when logging back in” option,
# although the checkbox will still appear to be checked. You can just ignore it.
#
# Mosyle has the option to add TALLogoutSavesState false and LoginwindowLaunchesRelaunchApps false
# through it's own config options.
#
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
