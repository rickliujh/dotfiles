#!/bin/bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
bash nvm install 20 && nvm use 20

pacman -S npm python python-pip python-setuptools cmake blas lapack
