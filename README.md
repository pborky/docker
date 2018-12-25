# OctoPrint-docker 

This repository contains everything you need to run [Octoprint](https://github.com/foosel/OctoPrint) in a docker environment on ARMHF.
Image size is around 300MB.

# Getting started

```
git clone https://github.com/pborky/octoprint-docker.git && cd octoprint-docker

./build 1.3.10 # empty argument for latest release 

# or docker build . --tag=octoprint:1.3.10 --build-arg tag=1.3.10

# search for you 3D printer serial port (usually it's /dev/ttyUSB0 or /dev/ttyACM0)
ls /dev | grep tty

// edit the docker-compose file to set your 3D printer serial port
vi docker-compose.yml

docker-compose up -d
```

You can then go to http://localhost:5000

You can display the log using `docker-compose logs -f`

## Without docker-compose
```
docker run -d -v $PWD/config:/var/octoprint/.octoprint --device /dev/ttyACM0:/dev/ttyACM0 -p 5000:5000 --name octoprint octoprint
```

# Additional tools

## FFMPEG

Octoprint allows you to make timelapses using an IP webcam and ffmpeg. Alpine distribution comes with ffmpeg package. 

