# BusyBox Web Server

BusyBox Web Server is a lightweight web server image that uses the BusyBox HTTP daemon. It provides basic web server functionality and is ideal for simple, non-security critical internal purposes.

## Features

- Support for CGI scripts (Shell)
- Basic authentication
- Custom error pages
- File upload functionality

## Installation

### Prerequisites

- Docker - obviously

### Installation and execution

```
git clone https://github.com/xsPQ/bb-webserver.git
cd bb-webserver
docker build -t bb-webserver .
docker run -d -p 80:80 --name bb-webserver -e EXAMPLE=true bb-webserver
```
