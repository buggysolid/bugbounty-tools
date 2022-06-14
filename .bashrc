export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/DNSCewl
export PATH=$PATH:$HOME/dirble/target/release
. "$HOME/.cargo/env"

getdns(){
subfinder -d $1 -silent -o subs.txt
}

gendns(){
TMPOUT_APPEND=$(tempfile)
TMPOUT_PREPEND=$(tempfile)
DNScewl -l subs.txt -a lists/wordlists/dns-keywords.txt | tail -n +15 >> $TMPOUT_APPEND
DNScewl -l subs.txt -p lists/wordlists/dns-keywords.txt | tail -n +15 >> $TMPOUT_PREPEND
cat subs.txt $TMPOUT_PREPEND $TMPOUT_APPEND > subs_permutated.txt
}

querydns(){
dnsx -silent -r lists/resolvers.txt -l subs_permutated.txt -o resolved.txt
}

http(){
httpx --silent -l resolved.txt -o http.txt
}

httpdir(){
dirble -k -t 2 --scan-401 --scan-403 --wordlist ~/lists/wordlists/http-keywords.txt --uri-file ~/http.txt --output-file httpdirs.txt
}

recon(){
getdns $1
gendns
querydns
http
httpdir
}
