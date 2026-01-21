#!/bin/bash

# Pull HarmonizeProject submodule
git submodule update --init --recursive HarmonizeProject

# Install HarmonizeProject deps
sudo apt-get update
sudo apt-get install -y screen bc python3-requests python3-dev python3-numpy python3-opencv python3-http-parser python3-zeroconf python3-termcolor libpython3-all-dev