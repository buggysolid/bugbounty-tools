#!/usr/bin/env bash

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export CC=/usr/bin/clang
export EDITOR=vim

gendns(){
    mksub -silent -df $HOME/$OUTPUT_DIR/subs.txt -w $HOME/bugbounty-wordlist/dns.txt -o $HOME/$OUTPUT_DIR/subs_permutated.txt
}

getdns(){
    subfinder -d $1 -silent -rL $HOME/bugbounty-wordlist/resolvers.txt -o $HOME/$OUTPUT_DIR/subs.txt
}

querydns(){
    dnsx -silent -a -aaaa -cname -retry 1 -r $HOME/bugbounty-wordlist/resolvers.txt -l $HOME/$OUTPUT_DIR/subs_permutated.txt -o $HOME/$OUTPUT_DIR/resolved.txt
    cat $HOME/$OUTPUT_DIR/resolved.txt | inscope > $HOME/$OUTPUT_DIR/resolved_inscope.txt
    # CNAMEs can end up pointing to something an A record was pointing to in the first place.
    sort -u $HOME/$OUTPUT_DIR/resolved_inscope.txt >> resolved_inscope_uniq.txt
}

http(){
    httpx -silent -retries 0 -timeout 1 -sd -sc -title -mc 404,403,401,301,302,200 -r $HOME/bugbounty-wordlist/resolvers.txt -l $OUTPUT_DIR/resolved_inscope.txt -o $HOME/$OUTPUT_DIR/http.txt
}

split_http_results_by_status_code(){
    awk '/200/' $HOME/$OUTPUT_DIR/http.txt | sort -ri -k3 >> 200.txt
    awk '/301/' $HOME/$OUTPUT_DIR/http.txt | sort -ri -k3 >> 301.txt
    awk '/302/' $HOME/$OUTPUT_DIR/http.txt | sort -ri -k3 >> 302.txt
    awk '/401/' $HOME/$OUTPUT_DIR/http.txt | sort -ri -k3 >> 401.txt
    awk '/403/' $HOME/$OUTPUT_DIR/http.txt | sort -ri -k3 >> 403.txt
    awk '/404/' $HOME/$OUTPUT_DIR/http.txt | sort -ri -k3 >> 404.txt
}

start(){
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
    split_http_results_by_status_code
}

start $1 $2
