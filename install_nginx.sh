#!/bin/bash

# installing ngnix webserver
sudo su
sudo amazon-linux-extras install nginx1 -y
sudo systemctl enable nginx
sudo systemctl start nginx