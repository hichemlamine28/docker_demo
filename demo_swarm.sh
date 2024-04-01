#!/bin/bash

docker swarm init --advertise-addr 192.168.1.21
# add worker nodes  folowing instructions

docker node ls
sudo docker service create --replicas 1 --name helloword alpine ping docker.com
docker service ls
docker ps

docker service create --name helloworld1 --mode global alpine ping docker.com

docker service inspect --pretty helloworld1
docker service inspect helloworld1

# To see which nodes are running the service:
docker service ps helloworld1

# To scale
docker service scale helloworld1=5

#To delete service
docker service rm helloworld1
docker service remove helloworld1

# Apply Rolling Update
docker service create --replicas 3 --name redis --update-delay 10s redis:3.0.6
docker service inspect --pretty redis
docker service update --image redis:3.0.7 redis
docker service inspect --pretty redis # First time
docker service inspect --pretty redis # Second time
docker service update redis
# Some nodes are still running redis 3.0.6 , wait till the update is made on all nodes
docker service ps redis
docker service create --replicas 10 --name my_web --update-delay 10s --update-parallelism 2 --update-failure-action continue alpine

# Placement Constraint
docker service create --name my-nginx --mode global --constraint node.labels.region==east --constraint node.labels.type!=devel nginx
# Placement Preference
docker service create --replicas 9 --name redis_2 --placement-pref 'spread=node.labels.datacenter' redis:3.0.6

# Rollback if failure update
docker service create --name=my_redis --replicas=5 --rollback-parallelism=2 --rollback-monitor=20s --rollback-max-failure-ratio=.2 redis:latest

# To drain worker (tell to manger to no more use this node and all runnning service related to sawrm will leave to another nodes, this does not affect local containers)
docker node update --availability drain worker1
docker node inspect --pretty worker1
# to rective wroker (un/drain)
docker node update --availability active worker1
docker node inspect --pretty worker1

# mode Routing Mesh
# publish port for service
docker service create --name my-web --publish published=8080,target=80 --replicas 2 nginx
# publish a port for an existing service
docker service update --publish-add published=9090,target=80 nginx

# Publish a port for TCP only or UDP only
docker service create --name dns-cache --publish published=53,target=53 dns-cache
docker service create --name dns-cache -p 53:53 dns-cache
# tcp + udp
docker service create --name dns-cache -p 53:53 -p 53:53/udp dns-cache

# Bypass the routing Mesh
docker service create --name dns-cache --publish published=53,target=53,protocol=udp,mode=host --mode global dns-cache

# Configure an external load balancer
# To use an external load balancer without the routing mesh, set --endpoint-mode to dnsrr
# You can't use --endpoint-mode dnsrr together with --publish mode=ingress

# To view the join command and token for manager nodes, run
docker swarm join-token manager

# Pass the --quiet flag to print only the token:
docker swarm join-token --quiet worker

# Run swarm join-token --rotate to invalidate the old token and generate a new token
docker swarm join-token  --rotate worker

# Join as a worker node
docker swarm join-token worker

# Join as a manager node
docker swarm join-token manager

# inspect an individual node
docker node inspect self --pretty


# Data Volume
docker service create --mount src=<VOLUME-NAME>,dst=<CONTAINER-PATH> --name myservice IMAGE

# Bind mount (between filesystem manager and containers)
docker service create --mount type=bind,src=<HOST-PATH>,dst=<CONTAINER-PATH> --name myservice IMAGE
docker service create --mount type=bind,src=<HOST-PATH>,dst=<CONTAINER-PATH>,readonly --name myservice IMAGE

# Promote or demote a node
docker node promote node-3 node-2
docker node demote node-3 node-2


# To leave swarm
docker swarm leave --force 

# To delete a Worker use this From manager:
docker node rm node-2

###################################################

##  SetUp a Docker registry
docker swarm init --advertise-addr 192.168.1.21
docker service create --name registry --publish published=5000,target=5000 registry:2
docker service ls
curl http://localhost:5000/v2/


mkdir stackdemo
cd stackdemo
docker compose up -d
docker compose ps
docker compose down --volumes
docker compose push
docker stack deploy --compose-file compose.yml stackdemo
docker stack deploy -c compose.yml stackdemo

docker stack services stackdemo

docker stack rm stackdemo



#  Docker secret

docker secret create homepage index.html
docker secret ls
docker service  create --name redis --secret my_secret_data redis:alpine
docker service update --secret-rm my_secret_data redis
docker secret rm my_secret_data



# Autolock
docker swarm init --autolock
docker swarm update --autolock=true
docker swarm update --autolock=false
docker swarm unlock
docker swarm unlock-key
docker swarm unlock-key --rotate
# Warning
# When you rotate the unlock key, keep a record of the old key around for a few minutes, so that if a manager goes down before it gets the new key, it may still be unlocked with the old one.

# Monitor Swarm Health
docker node inspect manager1 --format "{{ .ManagerStatus.Reachability }}"
docker node inspect manager1 --format "{{ .Status.State }}"

