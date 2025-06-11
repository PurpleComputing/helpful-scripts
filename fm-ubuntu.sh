# Update Ubuntu, run this multiple times until there are no more updates
apt update && apt upgrade

# Check & confirm Ubunto version
lsb_release -a

# Install needed packages
apt install wget
apt install unzip
apt install at

# Install FileMaker Server
cd ~/
mkdir fminstaller
cd fminstaller

# Download and unzip
wget https://downloads.claris.com/esd/fms_21.1.5.500_Ubuntu22_amd64.zip
unzip fms_21.1.5.500_Ubuntu22_amd64.zip

cd fm*

# Start installation
sudo ./install.sh

# Follow prompts during installation for license, type and admin credentials

# Check & confirm FileMaker Server & Nginx are running
ps -A | grep fm
ps -A | grep nginx
