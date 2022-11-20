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

### apt-get package manager

```
sudo apt-get install git -y
git clone https://github.com/buggysolid/bugbounty-tools
cd bugbounty-tools
chmod +x install.sh recon.sh
sudo runuser -u $USER ./install.sh
```

### yum/dnf package manager

```
sudo yum install git -y
git clone https://github.com/buggysolid/bugbounty-tools
cd bugbounty-tools
chmod +x install.sh recon.sh
sudo runuser -u $USER ./install.sh
```

## Example

Lets use the Elastic bug bounty program as an example. https://hackerone.com/elastic?type=team

### Wildcard scope scanning

```
root@ubuntu-c-4-8gib-ams3-01:~# ./bugbounty-tools/recon.sh elastic-cloud.com wildcard
api.fleet.me-south-1.aws.elastic-cloud.com
api-reference.asia-southeast1.gcp.elastic-cloud.com
api.europe-west2.gcp.elastic-cloud.com
api.europe-west2.gcp.elastic-cloud.com
```

### Defined scope scanning

```
root@ubuntu-s-1vcpu-1gb-ams3-01:~# echo '^.*\.gcp\.elastic-cloud\.com' > .scope
root@ubuntu-s-1vcpu-1gb-ams3-01:~# ./bugbounty-tools/recon.sh elastic-cloud.com
https://ws.apm.asia-south1.gcp.elastic-cloud.com 
https://staging.apm.us-central1.gcp.elastic-cloud.com 
```
