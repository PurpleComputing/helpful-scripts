cd /Library/Application\ Support/Purple
rm -rf speedtest-cli
curl -s -Lo speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py
chmod +x speedtest-cli
echo
python3 speedtest-cli --simple 