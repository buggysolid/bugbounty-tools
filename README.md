# Foreword

Do not run these tools/scripts against a target that is not part of a bug bounty program and or has not given you explicit permission. The scripts in this repo include directory brute forcing and port scanning which are loud and potentially disruptive activities.

# What is this?
An installer for tools commonly used in web application bug bounties during the recon phase. It also includes a .bashrc file with some commands I made to somewhat "automate" the invocation and chaining of the tools.

# Why?
Spending a lot of time on recon instead of actually looking at the web application you are testing is a massive waste of time. In general recon will find low hanging fruits and possibly give you some extra scope after you have exhausted the already given scope in the bug bounty program you are working on.

# How?

1. Spin up a VPS and or VM running a recentish (2022) Ubuntu distro.
2. Clone the repo.
3. Run the install script.
4. Look at the contents of the .bashrc to see how to use the tools.

Give me commands!

## Install

```
sudo apt-get install git -y
git clone https://github.com/buggysolid/bugbounty-tools
cd bugbounty-tools
./install.sh
cd
source $HOME/.bashrc
```
## Example

Lets use the Lime bug bounty program as an example. https://bugcrowd.com/lime

```
root@ubuntu-s-1vcpu-1gb-ams3-01:~# recon limeinternal.com
data-staging.limeinternal.com
pmm.limeinternal.com
limeinternal.com
ml-staging.limeinternal.com
... Lots of output and command chaining
root@ubuntu-s-1vcpu-1gb-ams3-01:~# ls *.txt
http.txt  httpdirs.txt  ports.txt  resolved.txt  resolved_inscope.txt  subs.txt  subs_permutated.txt
root@ubuntu-s-1vcpu-1gb-ams3-01:~#
```

http.txt - This will contain hostnames that are reachable over http or https. </br>
httpdirs.txt - This will contain hostnames that were reachable and a list of found directories for each hostname. </br>
ports.txt -This will contain hostnames that responded on the scanned port list found in bugbounty-wordlist/ports.txt </br>
resolved_inscope.txt - DNS queries that provided a response filtered for only ```*.limeinternal.com``` names. 


