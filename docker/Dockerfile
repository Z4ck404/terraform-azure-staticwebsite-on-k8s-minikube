FROM nginx:alpine

ARG giturl

RUN apk add --no-cache git
RUN git clone $giturl temp
RUN mv temp/* /usr/share/nginx/html/

EXPOSE 80

#CMD ["nginx", "-g", "daemon off;"]