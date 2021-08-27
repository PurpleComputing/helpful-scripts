cd /tmp
echo Downloading Purple DaisyDisk
sudo curl -o /tmp/dd.zip https://daisydiskapp.com/downloads/DaisyDisk.zip
echo Decompressing DaisyDisk
sudo unzip /tmp/dd.zip
echo Moving to Applications
sudo mv /tmp/DaisyDisk.app /Applications/DaisyDisk.app
echo Cleaning up files...
rm -rf dd.zip
sleep 2s
echo Finished
