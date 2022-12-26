# On and Off YouTube button

I use this to enable and disable YouTube in my home network on demand.

You will need to generate an ssh key and load it on your router. (all assumes router is at 10.0.0.1)

```
ssh-keygen -t rsa -C "your@email.com"

scp id_rsa.pub 10.0.0.1:/tmp

ssh admin@10.0.0.1

configure
loadkey admin /tmp/id_rsa.pub
commit
save
exit
```

After that you will need to generate a firewall rule (TBD document this)

Then build your container

```
docker build .
```


### List of IP addresses to add to blocker firewall

203.37.15.0/24
144.131.80.0/24
203.43.100.0/24
203.52.13.0/24
74.125.171.0/24
173.194.59.0/24
74.125.101.0/24
74.125.164.0/24
74.125.10.0/24
74.125.12.0/24
58.162.61.0/24
74.125.96.0/24
209.85.229.0/24

