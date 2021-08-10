### Microk8s with lxd 

## Install lxc and create a profile 

* [Official documentation](https://microk8s.io/docs/lxd)

* Summary

```
sudo snap install lxd
```

```
sudo lxd init
```

```
lxc profile create microk8s
```

```
wget https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s.profile -O microk8s.profile
```

```
cat microk8s.profile | lxc profile edit microk8s
```

## Create workers

```
lxc launch -p default -p microk8s ubuntu:20.04 master
```

```
lxc exec master -- sudo snap install microk8s --classic
```

```
lxc shell master
```

Copy and paste into the master shell 
```
cat > /etc/rc.local <<EOF
#!/bin/bash

apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*
exit 0
EOF
```

duplicate the master to work like nodes

```
lxc copy master w1
lxc copy master w2
lxc copy master w3
```

```
lxc start w1
lxc start w2
lxc start w3
```


## Add nodes to master
Execute the follow command and copy the  microk8s join command

```
lxc exec master -- sudo microk8s.add-node
```

```
lxc exec w1 -- sudo microk8s join <paste-the-token>
```

```
lxc exec master -- sudo microk8s kubectl get nodes
```

do the same for each nodes

## kubeconfig 
to use your local kubectl 
```
lxc exec master -- sudo microk8s config > kubeconfig.yaml
```

```
kubectl --kubeconfig=kubeconfig.yaml get nodes
```
Use as default kubectl config

```
cp kubeconfig.yaml ~/.kube/config
```
```
kubectl get nodes
```