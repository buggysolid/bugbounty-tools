export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

getdns(){
subfinder -d $1 -silent -rL $HOME/bugbounty-wordlist/resolvers.txt -o subs.txt
}

gendns(){
mksub -silent -df subs.txt -w $HOME/bugbounty-wordlist/dns.txt -o subs_permutated.txt
}

querydns(){
dnsx -silent -r $HOME/bugbounty-wordlist/resolvers.txt -l subs_permutated.txt -o resolved.txt
cat resolved.txt | inscope > resolved_inscope.txt
}

http(){
httpx -silent -l resolved_inscope.txt -o http.txt
}

httpdir(){
ffuf -u FUZZDOMAIN/FUZZDIR -w $HOME/http.txt:FUZZDOMAIN,$HOME/bugbounty-wordlist/http.txt:FUZZDIR -s -ac -se -mc 200 -o httpdirs.json
}

urls(){
cat $HOME/httpdirs.json | jq '.results[].url' | tr -d '"' | sort -u
}

recon(){
echo $1 > .scope
getdns $1
gendns
querydns
http
httpdir
urls
}
