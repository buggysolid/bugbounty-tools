echo 'Installing deps.'
wget 'https://go.dev/dl/go1.18.3.linux-amd64.tar.gz'
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
curl https://sh.rustup.rs -sSf | sh -s -- -y
sudo apt-get update && sudo apt-get install -y libpcap-dev git gcc build-essential
git clone https://github.com/codingo/DNSCewl
cd DNSCewl
make
cd ..
git clone https://github.com/buggysolid/bugbounty-tools
cp bugbounty-tools/.bashrc $HOME/.bashrc
source bugbounty-tools/.bashrc
echo 'Installing tools.'
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/ffuf/ffuf@latest
go install -v github.com/tomnomnom/hacks/inscope@latest
echo "Installing wordlists."
git clone https://github.com/buggysolid/bugbounty-wordlist
git clone https://github.com/danielmiessler/SecLists.git
echo "Run source $HOME/.bashrc for new paths to be loaded into your shell."
echo "Installed the following tools ffuf, httpx, dnsx, naabu, subfinder."
