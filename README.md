# Foreword

Do not run these tools/scripts against a target that is not part of a bug bounty program and or has not given you explicit permission.   

# What is this?

An installer and recon script using tools commonly used in web application bug bounties during the recon phase.  

ProjectDiscovery is the back bone of these scripts.

# Why?

Spending a lot of time on recon instead of actually looking at the web application you are testing is a massive waste of time.   

In general recon will find low hanging fruits and possibly give you some extra scope after you have exhausted the already given scope in the bug bounty program you are working on.  

# How?

1. Spin up a VPS and or VM running a recentish (2022) Ubuntu distro.
2. Clone the repo.
3. Run the install script.
4. Look at the examples below.

Give me commands!

## Install

```
sudo apt-get install git -y
git clone https://github.com/buggysolid/bugbounty-tools
cd bugbounty-tools
chmod +x install.sh
sudo runuser -u $USER ./install.sh
```

## Example

Lets use the Lime bug bounty program as an example. https://bugcrowd.com/lime

### Wildcard scope scanning

```
root@ubuntu-s-1vcpu-1gb-ams3-01:~# recon lime.bike wildcard
web-experimental-1.lime.bike
admintool-experimental.lime.bike
cdn.ops.lime.bike
web-staging.lime.bike
web.lime.bike
```

### Defined scope scanning

```
echo '^juicer\.lime\.bike' > .scope
recon lime.bike
juicer.lime.bike
```
