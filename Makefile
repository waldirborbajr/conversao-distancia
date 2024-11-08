buildpip:
	docker build -t waldirborbajr/conversao-distancia:v0.1.0 -f Dockerfile.v1 .

runpip:
	docker container run -d -p 8080:5000 waldirborbajr/conversao-distancia:v0.1.0

pushpip:
	docker push waldirborbajr/conversao-distancia:v0.1.0

latestpip:
	docker tag waldirborbajr/conversao-distancia:v0.1.0 waldirborbajr/conversao-distancia:latest
	docker push waldirborbajr/conversao-distancia:latest

build:
	docker build -t waldirborbajr/conversao-distancia:v0.2.3 -f Dockerfile .

run:
	docker container run -d -p 8181:5000 waldirborbajr/conversao-distancia:v0.2.3

prune:
	docker image prune

login:
	docker login

push:
	docker push waldirborbajr/conversao-distancia:v0.2.3

latest:
	docker tag waldirborbajr/conversao-distancia:v0.2.3 waldirborbajr/conversao-distancia:latest
	docker push waldirborbajr/conversao-distancia:latest

online:
	docker container run -d -p 8080:5000 waldirborbajr/conversao-distancia:latest

createcluster:
	k3d cluster create

createclusterprod:
	k3d cluster create challenge --servers 1 --agents 2

getnodes:
	kubectl get nodes

listcluster:
	k3d cluster list

deletecluster:
	k3d cluster delete

deploycluster:
	kubectl apply -f ./k8s/deployment.yaml
