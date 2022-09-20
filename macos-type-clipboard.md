
# macOS Type Clipboard
This Shortcut is incredibly useful to have added to your Dock or in the status bar. It allows you to copy a password from a field (or from ITGlue) and to launch the shortcut for it to type from the clipboard. I researched a solution for this after coming across a very complex password used for a Mac user account. This solves the inability to paste at a login window on both macOS or Windows through TeamViewer and other RDP softwares.

##### LINK TO SHORTCUT FOR MONTEREY
[https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/Type%20Clipboard.shortcut](https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/Type%20Clipboard.shortcut)
##### PPPC Permissions
The below permissions should be requested on first use, head to System Preferences > Security & Privacy > Privacy > Accessibility and tick the boxes to grant permissions.

Accessibility > Shortcuts

Accessibility > siriactionsd

### SCRIPT
```
on run
	tell application "System Events"
		delay 2 # DELAY BEFORE BEGINNING KEYPRESSES IN SECONDS
		repeat with char in (the clipboard)
			set cID to id of char
			
			if ((cID ≥ 48) and (cID ≤ 57)) then
				# Converts numbers to ANSI_# characters rather than ANSI_Keypad# characters
				# https://apple.stackexchange.com/a/227940
				key code {item (cID - 47) of {29, 18, 19, 20, 21, 23, 22, 26, 28, 25}}
			else if (cID = 46) then
				# Fix VMware Fusion period bug
				# https://apple.stackexchange.com/a/331574
				key code 47
			else
				keystroke char
			end if
			
			delay 0.5 # DELAY BETWEEEN EACH KEYPRESS IN SECONDS
		end repeat
	end tell
```
