[![CircleCI](https://dl.circleci.com/status-badge/img/circleci/XcfWh7FX5QpFKWFb9rXqFw/4cGj7TDUoHSEe7PXG8TuZB/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/circleci/XcfWh7FX5QpFKWFb9rXqFw/4cGj7TDUoHSEe7PXG8TuZB/tree/main)    
# postfix-container
Postfix docker container (intended as a backup MX or for testing)

## Docker Image

Creates a Docker Image of Postfix. 
The Primary intention is to use this image as a backup MX, testing email sending, or as a relay where needed.

On every start, the container will re-run the transport postmap. So if you need to change your transport maps, you just need to do a docker compose down and up. 

There is a sample docker-compose.yml for your convenience.   
Docker Hub Link: donswanson/postfix-container:latest     
Note, A new image will be built monthly to ensure any software updates to rectify major vulnerabilities are rectified.   

## Volumes

Volumes you may want to map are:

- /var/spool/postfix (Mail Queues)
- /config (Basic Config Files)

Optional
- /var/log (Log Files)
- /etc/postfix (ALL Config Directory)

## Ports

Ports to expose

- 25 (SMTP relay)
- 587 (Mail submission)
