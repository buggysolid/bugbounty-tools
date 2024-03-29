#!/usr/bin/env bash
echo 'Installing deps.'
if [[ -f "/usr/bin/apt" ]]; then
    sudo apt-get update && sudo apt-get install -y git jq clang wget util-linux libpcap-dev
elif [[ -f "/usr/bin/yum" ]]; then
    sudo yum makecache
    sudo yum install -y git jq clang wget util-linux libpcap-devel
else
  echo "Could not determine which package manager is installed."
  exit
fi

ARCH="$(uname -m)"

GO_LANG_DOWNLOAD_URL='https://go.dev/dl/go1.20.4.linux-amd64.tar.gz'

if [[ "aarch64" = "$ARCH" ]]; then
    GO_LANG_DOWNLOAD_URL='https://go.dev/dl/go1.20.4.linux-arm64.tar.gz'
fi

GO_LANG_TARBALL='golang.tar.gz'
wget $GO_LANG_DOWNLOAD_URL -O "$HOME/$GO_LANG_TARBALL"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$HOME/$GO_LANG_TARBALL"
# Drop priviledges
sudo -k

export CC=/usr/bin/clang
export PATH=$PATH:/usr/local/go/bin

# Hopefully we do not blow away anything useful a user has in their config.
echo 'CC=/usr/bin/clang' >> "$HOME/.bashrc"
echo 'PATH=$PATH:/usr/local/go/bin' >> "$HOME/.bashrc"
echo 'PATH=$PATH:$HOME/go/bin' >> "$HOME/.bashrc"

echo 'Installing tools.'
/usr/local/go/bin/go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest
$HOME/go/bin/pdtm -install dnsx,httpx,subfinder
/usr/local/go/bin/go install -v github.com/tomnomnom/hacks/inscope@latest
/usr/local/go/bin/go install -v github.com/trickest/mksub@latest
/usr/local/go/bin/go install -v github.com/famasoon/crtsh@latest

echo "Installing wordlists."
git clone https://github.com/buggysolid/bugbounty-wordlist "$HOME"/bugbounty-wordlist

echo "Installed tools."
echo "Finished."
