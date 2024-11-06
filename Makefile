buildpip:
	docker build -t waldirborbajr/conversao-distancia:v0.1.0 -f Dockerfile.v1 .

runpip:
	docker container run -d -p 8181:5000 waldirborbajr/conversao-distancia:v0.1.0

build:
	docker build -t waldirborbajr/conversao-distancia:v0.2.1 -f Dockerfile .

run:
	docker container run -d -p 8181:5000 waldirborbajr/conversao-distancia:v0.2.1

prune:
	docker image prune

login:
	docker login

push:
	docker push waldirborbajr/conversao-distancia:v0.2.1

latest:
	docker tag waldirborbajr/conversao-distancia:v0.2.1 waldirborbajr/conversao-distancia:latest
	docker push waldirborbajr/conversao-distancia:latest

online:
	docker container run -d -p 8080:5000 waldirborbajr/conversao-distancia:latest
