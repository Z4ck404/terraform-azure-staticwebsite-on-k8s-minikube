GIT_REPO ?="https://github.com/Z4ck404/z4ck404.github.io"
NAME = "elbazico"


build:

	@if [ "${GIT_REPO}" = "" ]; then \
		docker build -t elbazico:latest -f docker/Dockerfile .  ;\
	else \
		docker build -t ${NAME}:latest -f docker/Dockerfile . --build-arg giturl=${GIT_REPO} ;\
	fi

push:
	docker tag elbazico elbaziblog.azurecr.io/websites/elbazico:latest && docker push elbaziblog.azurecr.io/websites/elbazico:latest 

run: 
	docker run -p 80:80 zack:latest