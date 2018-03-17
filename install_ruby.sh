#!/bin/bash
sudo apt update
sudo apt install -y ruby-full ruby-bundler build-essential
if  ruby -v; then
	echo "Ruby runs!"
else 
	ehco "Something went wrong with ruby!"
fi
