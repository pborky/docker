#!/bin/bash

sudo chown 666:pi -R config
sudo chmod g+w -R config

docker run --rm -it -v $PWD/config:/var/octoprint/.octoprint -p 0.0.0.0:5000:5000 --device /dev/ttyACM0:/dev/ttyACM0 --name octoprint octoprint

