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


