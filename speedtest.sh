cd /Library/Application\ Support/Purple
curl -Lo speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py >/dev/null
chmod +x speedtest-cli
python3 speedtest-cli --simple 
