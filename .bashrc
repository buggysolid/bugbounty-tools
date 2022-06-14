export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/DNSCewl
export PATH=$PATH:$HOME/dirble/target/release
. "$HOME/.cargo/env"

getdns(){
subfinder -d $1 -silent -rL $HOME/bugbounty-wordlist/resolvers.txt -o subs.txt
}

gendns(){
TMPOUT_APPEND=$(tempfile)
TMPOUT_PREPEND=$(tempfile)
DNScewl -l subs.txt -a $HOME/bugbounty-wordlist/dns.txt | tail -n +15 >> $TMPOUT_APPEND
DNScewl -l subs.txt -p $HOME/bugbounty-wordlist/dns.txt | tail -n +15 >> $TMPOUT_PREPEND
cat subs.txt $TMPOUT_PREPEND $TMPOUT_APPEND > subs_permutated.txt
}

querydns(){
dnsx -silent -r $HOME/bugbounty-wordlist/resolvers.txt -l subs_permutated.txt -o resolved.txt
cat resolved.txt | inscope > resolved_inscope.txt
}

http(){
httpx --silent -l resolved_inscope.txt -o http.txt
}

httpdir(){
ffuf -u FUZZDOMAIN/FUZZDIR -w $HOME/http.txt:FUZZDOMAIN,$HOME/bugbounty-wordlist/http.txt:FUZZDIR | tee -a httpdirs.txt
}

recon(){
getdns $1
gendns
querydns
http
httpdir
}
