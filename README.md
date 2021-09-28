### Task 0: Install a ubuntu 16.04 server 64-bit

A ubuntu 16.04 virtual machine is installed on virtualbox. The host machine is a windows laptop.

### Task 1: Update system

I used mobaxterm to connect to the VM, and set the required port-forward information:
- 22->2222 for ssh
- 80->8080 for gitlab
- 8081/8082->8081/8082 for go app
- 31080/31081->31080/31081 for go app in k8s

For update, I used the following commands:
```
sudo apt-get update
sudo apt-get dist-upgrade
```

### Task 2: install gitlab-ce version in the host

I followed the procedure in https://about.gitlab.com/install/#ubuntu?version=ce
After installing, I can access gitlab from my host machine with the url localhost:8081

### Task 3: create a demo group/project in gitlab

named demo/go-web-hello-world (demo is group name, go-web-hello-world is project name).

### Task 4: build the app and expose ($ go run) the service to 8081 port

Please refer to go-web-app.go in this repository
```
curl http://127.0.0.1:8081
Go Web Hello World!
```

### Task 5: install docker

Followed the instrunction in https://docs.docker.com/install/linux/docker-ce/ubuntu/

### Task 6: run the app in container

Please refer to the Dockerfile in this repository.

Note that I have to turn of "GO111MODULE" to enable the container run the go application

Since the port 8082 is in use, I exposed the container to port 8083.

Commands:
```
docker build . -t go-web-hello-world
docker run -p 8083:8081 go-web-hello-world
```

Output:
```
curl http://127.0.0.1:8082
Go Web Hello World!
```

### Task 7: push image to dockerhub

Firstly I need to login using the command with my dockerhub credential, and then push the image to dockerhub.

Available at:
https://hub.docker.com/repository/docker/erfanw/go-web-hello-world

### Task 8: document the procedure in a MarkDown file

Refers to this README.md file

-----------------------------------

### Task 9: install a single node Kubernetes cluster using kubeadm

Followed https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/ to install kubeadm.

Checked in the admin.conf file into the gitlab repo

Important commands:
```
kubectl taint nodes --all node-role.kubernetes.io/master-  #To ba able to schedule pods
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

### Task 10: deploy the hello world container

Please refer to the deployment.yaml file in this repository.

Commands:
```
kubectl create -f deployment.yaml
kubectl expose deployment go-web-hello-world --type NodePort
kubectl edit svc go-web-hello-world  #then change "nodePort" to 31080
```

Output:
```
curl http://127.0.0.1:31080
Go Web Hello World!
```

------------------------------------

### Task 11: install kubernetes dashboard

Followed the instrunction in:

https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

Important commands:
```
kubectl proxy --port=31081
```

Output: https://127.0.0.1:31081 (asking for token)

### Task 12: generate token for dashboard login in task 11

Reference: https://www.replex.io/blog/how-to-install-access-and-add-heapster-metrics-to-the-kubernetes-dashboard

Commands:
```
kubectl create serviceaccount dashboard-admin-sa
kubectl create clusterrolebinding dashboard-admin-sa --clusterrole=cluster-admin --serviceaccount=default:dashboard-admin-sa
kubectl get secrets  #get the name of the secrets
kubectl describe secret dashboard-admin-sa-token-2tbfj  #get token
```

Then copy the token to the dashboard login page and then it will be able to the dashboard. 

### Task 13: publish your work

Available at https://github.com/erfanw/go-web-hello-world/
