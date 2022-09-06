FROM nginx:alpine

ARG giturl="https://github.com/Z4ck404/z4ck404.github.io"

RUN apk add --no-cache git
RUN git clone $giturl temp
RUN mv temp/* /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]