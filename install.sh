#!/usr/bin/env bash
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit
fi
echo 'Installing deps.'
wget 'https://go.dev/dl/go1.18.4.linux-amd64.tar.gz'
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.18.4.linux-amd64.tar.gz
sudo apt-get update && sudo apt-get install -y git jq clang
export CC=/usr/bin/clang
git clone https://github.com/buggysolid/bugbounty-tools "$HOME"/bugbounty-tools
\cp "$HOME"/bugbounty-tools/.bashrc "$HOME"/.bashrc
echo 'Installing tools.'
/usr/local/go/bin/go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
/usr/local/go/bin/go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
/usr/local/go/bin/go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
/usr/local/go/bin/go install -v github.com/ffuf/ffuf@latest
/usr/local/go/bin/go install -v github.com/tomnomnom/hacks/inscope@latest
/usr/local/go/bin/go install -v github.com/trickest/mksub@latest
echo "Installing wordlists."
git clone https://github.com/buggysolid/bugbounty-wordlist "$HOME"/bugbounty-wordlist
echo "Run source $HOME/.bashrc for new paths to be loaded into your shell."
echo "Installed the following tools ffuf, httpx, dnsx, subfinder, inscope and mksub."
