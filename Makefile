GIT_REPO ?="https://github.com/Z4ck404/z4ck404.github.io"
NAME = "elbazico"
AZURECR = "elbaziblog"

_login:
	az acr login -n ${AZURECR}

build:

	@if [ "${GIT_REPO}" = "" ]; then \
		docker build --platform linux -t elbazico:latest -f docker/Dockerfile .  ;\
	else \
		docker build --platform linux -t ${NAME}:latest -f docker/Dockerfile . --build-arg giturl=${GIT_REPO} ;\
	fi

push: _login
	docker tag elbazico ${AZURECR}.azurecr.io/websites/elbazico:latest && docker push ${AZURECR}.azurecr.io/websites/elbazico:latest 

run: 
	docker run -p 80:80 ${NAME}:latest