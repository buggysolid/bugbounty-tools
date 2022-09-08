export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export CC=/usr/bin/clang
export EDITOR=vim

getdns(){
subfinder -d $1 -silent -rL $HOME/bugbounty-wordlist/resolvers.txt -o $HOME/$OUTPUT_DIR/subs.txt
}

gendns(){
mksub -silent -df $HOME/$OUTPUT_DIR/subs.txt -w $HOME/bugbounty-wordlist/dns.txt -o $HOME/$OUTPUT_DIR/subs_permutated.txt
}

querydns(){
dnsx -silent -r $HOME/bugbounty-wordlist/resolvers.txt -l $HOME/$OUTPUT_DIR/subs_permutated.txt -o $HOME/$OUTPUT_DIR/resolved.txt
cat $HOME/$OUTPUT_DIR/resolved.txt | inscope > $HOME/$OUTPUT_DIR/resolved_inscope.txt
}

http(){
httpx -silent -l $OUTPUT_DIR/resolved_inscope.txt -o $HOME/$OUTPUT_DIR/http.txt
}

httpdir(){
ffuf -u FUZZDOMAIN/FUZZDIR -w $HOME/$OUTPUT_DIR/http.txt:FUZZDOMAIN,$HOME/bugbounty-wordlist/http.txt:FUZZDIR -s -ac -se -mc 200 -fr "not found" -fr "JavaScript enabled" -o $HOME/$OUTPUT_DIR/httpdirs.json
}

urls(){
cat $HOME/$OUTPUT_DIR/httpdirs.json | jq '.results[].url' | tr -d '"' | sort -u | tee -a $HOME/$OUTPUT_DIR/urls.txt
}

recon(){
if [[ "$2" == "wildcard" ]]; then
	echo "$1" > .scope
elif [[ ! -f ".scope" ]]; then
	echo "Define a regular expression of the scope in a .scope file."
	echo "Documentation https://github.com/tomnomnom/hacks/tree/master/inscope"
	echo
	echo "If you want to assume wildcard scope pass 'wildcard' without quotes as the second argument."
	echo
	echo "Usage: recon somedomain.tld wildcard"
	return -1
fi
OUTPUT_DIR="$(mktemp -d -p . $1.XXXXXX)"
getdns $1
gendns
querydns
http
httpdir
echo
echo
echo
echo
urls
}
