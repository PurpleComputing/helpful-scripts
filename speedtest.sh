runAsUser() {  
	currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
	currentUserID=$(id -u "$currentUser")

  if [ "$currentUser" != "loginwindow" ]; then
    /bin/launchctl asuser "$currentUserID" sudo -u "$currentUser" "$@"
  fi
}

cd /Library/Application\ Support/Purple
rm -rf speedtest-cli
curl -s -Lo speedtest-cli https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/speedtest
xattr -r -d com.apple.quarantine speedtest-cli
chmod 777 speedtest-cli
echo Running Speed Test
sleep 10

runAsUser /Library/Application\ Support/Purple/speedtest-cli --accept-license --accept-gdpr >> /tmp/speedtest.log
