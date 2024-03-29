#!/usr/bin/env bash
# mOSL/Lockdown

# Lockdown
#   Lockdown macOS Catalina security settings
declare -r LOCKDOWN_VERSION="v3.2.1"

set -uo pipefail
# -u prevent using undefined variables
# -o pipefail force pipelines to fail on first non-zero status code

IFS=$'\n\t'
# Set Internal Field Separator to newlines and tabs
# This makes bash consider newlines and tabs as separating words
# See: http://redsymbol.net/articles/unofficial-bash-strict-mode/

### Define Colours ###

/usr/bin/tput sgr0; 
# reset colors

readonly RED="$(/usr/bin/tput setaf 1)"
readonly RESET="$(/usr/bin/tput sgr0)"
readonly BOLD="$(/usr/bin/tput bold)"

### END Colours ###


function usage {
  echo -e "\\n  Audit or Fix macOS security settings🔒🍎\\n"
  echo -e "  Usage: ./Lockdown [list | audit {setting} | fix {setting} | version | debug]\\n"

  echo "    list         - List settings that can be audited/ fixed" 
  echo "    audit        - Audit the status of all or chosen setting"
  echo -e "    ${RED}fix${RESET}          - Attempt to fix all or chosen setting\\n"
  echo "    ${RED}fix-force${RESET}    - Same as 'fix' however bypasses user confirmation prompt"
  echo -e "                   (Can be used to invoke Lockdown from other scripts)\\n"
  echo "    version      - Print Lockdown version string"
  echo -e "    debug        - Print debug info for troubleshooting\\n"

  exit 0
}


### UTILITY FUNCTIONS ###
# macos_compatability_check
# audit
# fix
# mode_check
# get_fix_mode_permission
# follow_symlink
# verify_signature
# check_index
# sudo_prompt
# ctrl_c
# check_if_vm
# check_sip
# debug
# full_disk_access_check
# version



function audit {

  local title=${1:?No title passed}
  local command=${2:?No command passed}

  if bash -c "${command}"; then
	echo "  [✅] ${title}"
	return 0
  else
	echo "  [❌] ${title}"
	return 1
  fi
}


function fix {

  local title=${1:?No title passed}
  local command=${2:?No command passed}

  if [[ "${command}" == "null" ]]; then
	echo "  [⚠️ ] ${BOLD}Can't fix${RESET}: ${title}"
	return 1
  fi

  if bash -c "${command}"; then
	echo "  [✅] ${BOLD}FIXED${RESET}: ${title}"

	if [[ "${title}" == "Check SIP enabled" ]]; then
	  echo "  [⚠️ ] ${BOLD}Reboot required for SIP configuration changes to take effect"
	fi
	return 0
  else
	echo "  [❌] ${BOLD}Failed to fix${RESET}: ${title}"
	return 1
  fi
}


function mode_check {

  local mode=${1:?}
  local title=${2:?}
  local audit_command=${3:?}
  local fix_command=${4:-"null"}

  if [[ "${mode}" == "audit" ]]; then
	audit "${title}" "${audit_command}"

  elif [[ "${mode}" == "fix" ]]; then
	fix "${title}" "${fix_command}"
  fi
}


function get_fix_mode_permission {

  # Double check with user before making changes to their system

  local fix_mode_permission=""

  echo "[⚠️ ] You are about to engage ${BOLD}${RED}FIX${RESET} mode which ${BOLD}${RED}WILL${RESET} make changes to your Mac 💻"
  echo -n "[⚠️ ] Do you want to continue? (y/${BOLD}N${RESET}) "
  read -r fix_mode_permission

  if [[ "${fix_mode_permission}" =~ ^(y|Y)$ ]]; then
	
	echo "[✅] ${USER} has chosen to continue"
	sudo_prompt
	return 0
  
  else
	echo "[❌] ${USER} has chosen to quit!"
	exit 1
  fi
}


function follow_symlink {

  # If Lockdown is symlinked in $PATH
  # Follow the symlink(s) to the real location of Lockdown
  # This is required for Minisign to verify the signature

  base=$(/usr/bin/basename "${0}")
  # Lockdown
  source="${BASH_SOURCE[0]}"
  # /x/y/z/Lockdown
  while [ -h "${source}" ]; do
	# While $source is a symlink
	dir="$(cd -P "$(/usr/bin/dirname "${source}")" && pwd)"
	# Get directory of $source
	# cd into dir of $source and run `pwd`
	source="$(/usr/bin/readlink "${source}")"
	# get target of $source symlink 
	
	if [[ "${source}" != /* ]]; then 
	  source="${dir}/${source}"
	fi
  
  done
  parent=$(/usr/bin/dirname "${source}")
  # get directory of $source
  lockdown_path="$(cd -P "${parent}" && pwd)/${base}"
  # Build path to Lockdown
}




function check_index {

  # Check that index supplied to audit/ fix isn't greater than the number of entries in settings 

  local setting_num=${1:-0}
  local -i max_setting_num
  max_setting_num=$(( ${#settings[@]} - 1 ))

  if ! [[ "${setting_num}" =~ ^-?[0-9]+$ ]] ; then
   echo -e "\\n  [❌] ${setting_num} ${RED}is not an integer!${RESET}"
   echo "  [⚠️ ] Pick a setting between 1 and ${max_setting_num}"
   exit 1
  fi

  if [ "${setting_num}" -gt "${max_setting_num}" ]; then
	echo -e "\\n  [❌] ${RED}No setting with index of ${setting_num}${RESET}" 
	echo "  [⚠️ ] Pick a setting between 1 and ${max_setting_num}"
	exit 1
  fi
}


function sudo_prompt {

  sudo --prompt="[⚠️ ] Password required to run some commands with 'sudo': " -v
  # Aquire sudo privlidges now so we can show a custom prompt
  # -v updates the user's cached credentials, does not run a command
}


function ctrl_c {
  
		echo -e "\\n[❌] ${USER} has chosen to quit!"
		exit 1
}

function check_if_vm {

  if system_profiler SPHardwareDataType | grep -q "VMware";  then
	# TODO: Only detects VMware. Add VirtualBox, Parallels, generic? 
	return 0
  else
	return 1
  fi
}

function check_sip {

  if csrutil status | grep -q "enabled"; then
	return 0
  else
	return 1
  fi
}

function debug {

  local is_admin="False"
  local has_full_disk_access="False"

  if /usr/bin/groups | /usr/bin/grep -q 'admin'; then
	is_admin="True"
  fi

  if full_disk_access_check; then
	has_full_disk_access="True"
  fi

  if check_if_vm; then
	is_vm="True"
  fi

  if verify_signature >/dev/null 2>&1; then 
	is_codesigned="True"
	# If the signature has been broken and you uncomment the 
	# call to verify_signature in main and try to run 
	# ./Lockdown debug this verify_signature call will still
	# exit 1 with no explanation
  fi

  if check_sip; then
	sip="True"
  fi

  echo -e "${RED}Debug information:${RESET} \\n"

  echo "      mOSL Version:   ${LOCKDOWN_VERSION}"
  /usr/sbin/system_profiler SPSoftwareDataType | /usr/bin/grep 'Version'
  echo "      Is admin:       ${is_admin}"
  echo "      Full Disk Access: ${has_full_disk_access}"
  echo "      Virtual Machine: ${is_vm}"
  echo "      Codesigned:      ${is_codesigned}"
  # Codesigned will only ever be "True" or "no minisign" as
  # verify_signature is the first thing called in main so Lockdown 
  # will exit before it evaluates $cmd
  echo "      SIP:             ${sip}"
  echo "      T2:              ${t2_mac}"
  echo

  exit 0
}


function full_disk_access_check {

  if [ -r "$HOME/Library/Mail" ]; then
	return 0
  else
	return 1
  fi
}

function version {
  echo "${LOCKDOWN_VERSION}"
}


### END UTILITY FUNCTIONS ###


function enable_automatic_system_updates {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Enable Automatic System Updates"

  # shellcheck disable=SC2016
  audit_command='if ! defaults read "/Library/Preferences/com.apple.SoftwareUpdate.plist" "AutomaticallyInstallMacOSUpdates" >/dev/null 2>&1; then exit 1; fi; defaults read "/Library/Preferences/com.apple.SoftwareUpdate.plist" AutomaticallyInstallMacOSUpdates | grep -q "1"'
  # shellcheck disable=SC2016
  fix_command='declare -a keys; keys=(AutomaticCheckEnabled AutomaticDownload AutomaticallyInstallMacOSUpdates ConfigDataInstall CriticalUpdateInstall); for key in "${keys[@]}"; do sudo defaults write "/Library/Preferences/com.apple.SoftwareUpdate.plist" "${key}" -bool true; done'
  
  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function enable_automatic_app_store_updates {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Enable Automatic App Store Updates"

  audit_command='if ! defaults read "/Library/Preferences/com.apple.commerce.plist" "AutoUpdate" >/dev/null 2>&1; then exit 1; fi; defaults read "/Library/Preferences/com.apple.commerce.plist" "AutoUpdate" | grep -q "1"'
  fix_command="sudo defaults write '/Library/Preferences/com.apple.commerce.plist' 'AutoUpdate' -bool true"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function enable_gatekeeper {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Enable Gatekeeper"

  audit_command='spctl --status | grep -q "assessments enabled"'
  fix_command='sudo spctl --master-enable'

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function enable_firewall {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Enable Firewall"

  audit_command="sudo /usr/libexec/ApplicationFirewall/socketfilterfw  --getglobalstate | grep -q 'enabled'"
  fix_command="sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on >/dev/null"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function enable_admin_password_preferences {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Require an administrator password to access system-wide preferences"

  audit_command="security -q authorizationdb read system.preferences | grep -A1 'shared' | grep -q 'false'"
  fix_command="security -q authorizationdb read system.preferences > /tmp/system.preferences.plist; /usr/libexec/PlistBuddy -c 'Set :shared false' /tmp/system.preferences.plist; sudo security -q authorizationdb write system.preferences < /tmp/system.preferences.plist; rm '/tmp/system.preferences.plist'"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function enable_terminal_secure_entry {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Enable Terminal.app secure keyboard entry"

  audit_command="defaults read com.apple.Terminal SecureKeyboardEntry | grep -q '1'"
  fix_command="defaults write com.apple.Terminal SecureKeyboardEntry -bool true"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function enable_sip {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Enable System Integrity Protection (SIP)"

  audit_command="csrutil status | grep -q 'enabled'"
  fix_command="sudo csrutil clear >/dev/null"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function enable_filevault {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  local permission="n"
  
  title="Enable FileVault"

  audit_command="fdesetup status | grep -q 'On'"
  fix_command="sudo fdesetup enable -user $USER > $HOME/FileVault_recovery_key.txt"


  if [[ "${mode}" == "fix" ]]; then

	if ! /usr/sbin/diskutil info / | /usr/bin/grep 'File System Personality:' | /usr/bin/grep -q 'APFS'; then
	  # Only offer to enable if the filesystem is APFS 
	  return 1
	elif [[ "${cmd}" == "fix-force" ]]; then
	  # Exit if Lockdown invoked with fix-force
	  # Enabling FDE should be explicit, don't want anyone to do this by accident
	  echo "  [⚠️ ] ${BOLD}Didn't fix${RESET}: ${title}" 
	  return 1
	fi

	echo -en "\\n  [⚠️ ] Do you want to ${RED}enable FileVault${RESET}? (y/${BOLD}N${RESET}) "
	read -r permission

	if [[ "${permission}" =~ ^(y|Y)$ ]]; then
	  
	  echo "  [✅] ${USER} has chosen to enable FileVault"
	  echo -e "  [⚠️ ] Recovery key saved to ${RED}$HOME/FileVault_recovery_key.txt${RESET}\\n"

	else
	  echo -e "  [❌] ${USER} has chosen ${BOLD}not${RESET} to enable FileVault\\n"
	  return 1
	fi
  fi

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function disable_firewall_builin_software {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Disable built-in software from being auto-permitted to listen through firewall"

  audit_command="sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getallowsigned | grep 'built-in' | grep -q 'DISABLED'"
  fix_command="sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off >/dev/null"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function disable_firewall_downloaded_signed {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Disable downloaded signed software from being auto-permitted to listen through firewall"

  audit_command="sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getallowsigned | grep 'downloaded' | grep -q 'DISABLED'"
  fix_command="sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off >/dev/null"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function disable_ipv6 {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Disable IPv6"

  # shellcheck disable=SC2016
  audit_command='while IFS= read -r i; do if ! networksetup -getinfo "${i}" | grep -q "IPv6: Off"; then exit 1; fi; done <<< $(networksetup -listallnetworkservices | tail -n $(( $(networksetup -listallnetworkservices | wc -l) - 1 )))'
  # shellcheck disable=SC2016
  fix_command='while read -r i; do sudo networksetup -setv6off "${i}"; done <<< "$(networksetup -listallnetworkservices | tail -n $(( $(networksetup -listallnetworkservices | wc -l) - 1 )))"'

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function disable_mail_remote_content {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Disable automatic loading of remote content by Mail.app"

  if ! full_disk_access_check; then 
	echo "  [⚠️ ] ${title} (${RED}Requires 'Full Disk Access' permission${RESET})"
	return 1
  fi

  audit_command="defaults read com.apple.mail-shared DisableURLLoading 2>/dev/null | grep -q '1'"
  fix_command="defaults write com.apple.mail-shared DisableURLLoading -bool true"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function disable_remote_apple_events {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Disable Remote Apple Events"

  audit_command="sudo systemsetup -getremoteappleevents | grep -q 'Remote Apple Events: Off'"
  fix_command="sudo systemsetup -setremoteappleevents off >/dev/null"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function disable_remote_login {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Disable Remote Login"

  audit_command="sudo systemsetup -getremotelogin | grep -q 'Remote Login: Off'"
  fix_command="sudo systemsetup -f -setremotelogin off >/dev/null"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function disable_auto_open_safe_downloads {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command

  title="Disable Safari Auto Open 'safe' Files"

  if ! full_disk_access_check; then 
	echo "  [⚠️ ] ${title} (${RED}Requires 'Full Disk Access' permission${RESET})"
	return 1
  fi
  
  audit_command="defaults read com.apple.Safari AutoOpenSafeDownloads 2>/dev/null | grep -q '0'"
  fix_command="defaults write com.apple.Safari AutoOpenSafeDownloads -bool false"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function set_airdrop_contacts_only {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Set AirDrop Discoverability to 'Contacts Only'"

  audit_command="if defaults read com.apple.sharingd DiscoverableMode 2>/dev/null | grep -q 'Contacts Only'; then exit 0; elif defaults read com.apple.sharingd DiscoverableMode 2>/dev/null | grep -q 'Off'; then exit 0; else exit 1; fi"
  fix_command="defaults write com.apple.sharingd DiscoverableMode -string 'Contacts Only' \
			  && sudo killall -HUP sharingd"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function set_appstore_update_check_daily {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Set AppStore update check to every one (1) day"

  audit_command="defaults read com.apple.SoftwareUpdate ScheduleFrequency 2>/dev/null | grep -q '1'"
  fix_command="defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1"

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function check_kext_loading_consent {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Check Kernel Extension User Consent required"

  audit_command="spctl kext-consent status | grep -q 'ENABLED'"
  fix_command=''

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function check_efi_integrity {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="Check EFI Firmware Integrity"

  audit_command="/usr/libexec/firmwarecheckers/eficheck/eficheck --integrity-check >/dev/null 2>&1"
  fix_command=''


  if /usr/sbin/system_profiler SPiBridgeDataType | /usr/bin/grep 'Model Name:' | /usr/bin/grep -q 'T2'; then 
	echo "  [⚠️ ] ${title} (${RED}Not supported on Macs with T2 chips${RESET})"
	t2_mac="True"
	return 1 
  fi
  
  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function set_firmware_password {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  local permission="n"
  
  title="Set a firmware password"
  audit_command="sudo firmwarepasswd -check | grep -q 'Yes'"
  fix_command="sudo firmwarepasswd -setpasswd"

  if check_if_vm; then
	echo "  [⚠️ ] ${title} (${RED}Can't set a firmware password in a VM${RESET})"
	return 1
  fi

  if [[ "${mode}" == "fix" ]]; then

	if [[ "${cmd}" == "fix-force" ]]; then
	  # Exit if Lockdown invoked with fix-force
	  # Enabling FDE should be explicit, don't want anyone to do this by accident
	  echo "  [⚠️ ] ${BOLD}Didn't fix${RESET}: ${title}" 
	  return 1
	fi
	
	echo -en "\\n  [⚠️ ] Do you want to ${RED}set a Firmware password?${RESET} (y/${BOLD}N${RESET}) "
	read -r permission

	if [[ "${permission}" =~ ^(y|Y)$ ]]; then
	  echo "  [✅] ${USER} has chosen to set a firmware password"
	else
	  echo -e "  [❌] ${USER} has chosen ${BOLD}not${RESET} to set a firmware password\\n"
	  return 1
	fi
  fi

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


function check_if_standard_user {

  local mode=${1:?No mode passed}
  local title
  local audit_command
  local fix_command
  
  title="${USER} should not be an administrator"

  audit_command="groups | grep -qv 'admin'"
  fix_command=""

  mode_check "${mode}" "${title}" "${audit_command}" "${fix_command}"
}


############################ 


function main {

  # Verify Lockdown signature 
  # Check the system is running the supoorted version of macOS 

  declare -r cmd=${1:-"usage"}
  declare -a settings
  declare -i setting_index=-1
  declare audit_setting_num
  declare fix_setting_num
  declare t2_mac="False"
  declare is_vm="False"
  declare is_codesigned="False"
  declare sip="False"

  settings=(enable_automatic_system_updates enable_automatic_app_store_updates enable_gatekeeper enable_firewall enable_admin_password_preferences \
				  enable_terminal_secure_entry enable_sip enable_filevault \
				  disable_firewall_builin_software disable_firewall_downloaded_signed \
				  disable_ipv6 disable_mail_remote_content disable_remote_apple_events disable_remote_login \
				  disable_auto_open_safe_downloads set_airdrop_contacts_only set_appstore_update_check_daily \
				  set_firmware_password check_kext_loading_consent check_efi_integrity check_if_standard_user)

  trap ctrl_c SIGINT
  # Detect and react to the user hitting CTRL + C

  case "${cmd}" in

	list)
	  echo -e "\\nSettings (${BOLD}${#settings[@]}${RESET}) that can be audited or fixed: "
	  
	  for setting in "${settings[@]}"; do
		setting_index=$((setting_index+1)) 

		# shellcheck disable=SC2116
		setting_read="$(echo "${setting//_/ }")"
		# Replace underscore with a space, more human readable
		echo "  (${RED}${setting_index}${RESET}) ${setting_read}"
	  done
	  
	  echo
	  exit 0
	  ;;

	audit)
	  audit_setting_num=${2:--1}

	  check_index "${audit_setting_num}"
	  sudo_prompt

	  echo -e "\\nResults: "
	  
	  if ! [ "${audit_setting_num}" -lt 0 ]; then
		"${settings[${audit_setting_num}]}" "audit"
	  else

		for setting in "${settings[@]}"; do 
		  "${setting}" "audit"
		  # Call functions in 'settings' array with the argument 'audit'
		done
	  fi

	  echo
	  ;;

	fix|fix-force)
	  fix_setting_num=${2:--1}

	  check_index "${fix_setting_num}"

	  if [[ "${cmd}" != "fix-force" ]]; then
		# Confirm the user wants to run FIX mode
		# If "fix force" skip the prompt 
		  get_fix_mode_permission
	  fi

	  echo -e "\\nResults: "

	  if ! [ "${fix_setting_num}" -lt 0  ]; then
		"${settings[${fix_setting_num}]}" "audit"
	  
	  else

		for setting in "${settings[@]}"; do 

		  if ! "${setting}" "audit" >/dev/null; then
		  # Run the audit command first
		  # Only run the fix command if audit fails
		  "${setting}" "fix"
		  fi
		done
	  fi

	  echo
	  ;;

	debug)
	  debug
	  ;;

	usage|help|-h|--help|🤷‍♂️|🤷‍♀️)
	  usage
	  ;;

	version|-v|--version)
	  version
	  ;;
	
	*)
	  echo -e "\\n  [❌] ${RED}Invalid command:${RESET} ${cmd}"
	  exit 1
	  ;;

  esac

}

main "$@"
