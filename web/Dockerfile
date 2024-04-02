FROM nginx
RUN apt update -y && \
    apt install nano vim -y
COPY index.html /usr/share/nginx/html/
EXPOSE 80