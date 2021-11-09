# RUN SCRIPT ON LOGIN AND LOGOUT TO PREVENT 'Reopen windows when logging back in'.
# This effectively disables the “reopen windows when logging back in” option,
# although the checkbox will still appear to be checked. You can just ignore it.
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false
