build:
	docker build -t waldirborbajr/conversao-distancia:v0.1.0 -f Dockerfile.v1 .

run:
	docker container run -d -p 8181:5000 conversao-distancia

prune:
	docker image prune

login:
	docker login

push:
	docker push waldirborbajr/conversao-distancia:v0.1.0
