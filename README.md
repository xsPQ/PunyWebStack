# PunyWebStack


PunyWebStack is a puny (but lightweight) web stack that uses the BusyBox HTTP daemon with CGI-Support (Shell). It provides basic web server functionality and is ideal for simple, non-security critical internal purposes. 

## !!!

Now that I have this repo public:
For god's sake please don't use this somewhere (productive).


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
docker build -t pws .
docker run -d -p 80:80 --name PunyWebStack -e EXAMPLE=true pws
```
