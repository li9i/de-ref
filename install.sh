# Download latest release of yq (amd64)
sudo apt-get install wget
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O yq
chmod +x yq
sudo mv yq /usr/local/bin/yq
yq --version
