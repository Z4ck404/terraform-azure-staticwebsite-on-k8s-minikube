GIT_REPO ?="https://github.com/Z4ck404/z4ck404.github.io"
NAME = "zack"


build:

	@if [ "${GIT_REPO}" = "" ]; then \
		docker build -t zack:latest -f docker/Dockerfile .  ;\
	else \
		docker build -t ${NAME}:latest -f docker/Dockerfile . --build-arg giturl=${GIT_REPO} ;\
	fi

run: 
	docker run -p 80:80 zack:latest