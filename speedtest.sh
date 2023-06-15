cd /Library/Application\ Support/Purple
rm -rf speedtest-cli
curl -s -Lo speedtest-cli https://github.com/PurpleComputing/mdmscripts/raw/main/Helpers/speedtest
xattr -r -d com.apple.quarantine speedtest-cli
chmod +x speedtest-cli
echo
 ./speedtest-cli --accept-license --accept-gdpr >> /tmp/speedtest.log
