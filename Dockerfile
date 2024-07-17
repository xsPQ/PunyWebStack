# BBWS-Server Dockerfile
# Author: Stephan Gaessler

FROM busybox:latest
ENV PORT=80
ENV EXAMPLE=false
LABEL maintainer="Stephan Gaessler zyx.cpskrw@gs"

# Create directories
RUN mkdir -p /docker /example/config /example/www/{auth,cgi-bin,css,upload} /www /config

# Add Docker image data
ADD ./docker/start.sh /docker/start.sh
ADD ./docker/readme.md /readme.md
RUN chmod +x /docker/start.sh

# Add HTML files
ADD ./example/www/index.html /example/www/index.html
ADD ./example/www/404.html /example/www/404.html
ADD ./example/www/css/mvp.css /example/www/css/mvp.css
ADD ./example/www/upload.html /example/www/upload.html
ADD ./example/www/upload_api.html /example/www/upload_api.html


# Add CGI scripts
ADD ./example/www/cgi-bin/upload.cgi /example/www/cgi-bin/upload.cgi
ADD ./example/www/cgi-bin/print-env.cgi /example/www/cgi-bin/print-env.cgi
ADD ./example/www/cgi-bin/upload_api.cgi /example/www/cgi-bin/upload_api.cgi
RUN chmod +x /example/www/cgi-bin/upload.cgi /example/www/cgi-bin/print-env.cgi

# Add example httpd.conf
ADD ./example/config/httpd.conf /example/config/httpd.conf

# EXPOSE $PORT
HEALTHCHECK CMD nc -z localhost $PORT

# Execute start script
CMD /docker/start.sh
