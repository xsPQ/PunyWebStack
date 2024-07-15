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
git clone https://github.com/xsPQ/PunyWebStack.git
cd PunyWebStack
docker build -t PunyWebStack .
docker run -d -p 80:80 --name PunyWebStack -e EXAMPLE=true PunyWebStack
```
