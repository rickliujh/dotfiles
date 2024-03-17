# Usage
# docker build -f=nodedev.Dockerfile -t=nvimnode:v0.1 --build-arg=EMAIL={{YOUR_EMAIL}} --build-arg=NAME={{YOUR_NAME}} --build-arg=PASSWD={{YOUR_PASSWD}} .
# docker run -v ~/workspace/{{YOUR-PROJECT}}:/root/{{YOUR-PROJECT}} -p 8654:22 --name {{IMAGE_NAME}} -d -it nvimnode:v0.1
# ssh user@<hostname> -p 8654 -t "tmux new -s {{TMUX_SESSION}}" for the first time, and
# ssh user@<hostname> -p 8654 -t "tmux a -t {{TMUX_SESSION}}"

FROM ubuntu:24.04

WORKDIR /root

ARG EMAIL
ARG NAME
ARG PASSWD=root

ENV EMAIL=$EMAIL
ENV NAME=$NAME
ENV PASSWD=$PASSWD

# Install things
RUN apt update && \
	apt install -y git && \
	git clone https://github.com/rickliujh/dotfiles.git && \
	cd ./dotfiles && \
	bash setup.sh install_without_languages && \
	bash setup.sh backup_configs && \
	bash setup.sh setup_symlinks && \
	bash setup.sh install_dev_pkgs && \
	curl -fsSL "https://deb.nodesource.com/setup_lts.x" | bash - && apt install -y nodejs && \
	corepack enable && \
	rm -rf setup_lts.x 
	
# Setup SSH and git
RUN apt install -y openssh-server && \
	apt clean && \
	sed -i'' -e's/^#PermitRootLogin prohibit-password$/PermitRootLogin yes/' /etc/ssh/sshd_config && \
        sed -i'' -e's/^#PasswordAuthentication yes$/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
        sed -i'' -e's/^#PermitEmptyPasswords no$/PermitEmptyPasswords yes/' /etc/ssh/sshd_config && \
        sed -i'' -e's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
	sed -i "s/email =.*/email = ${EMAIL}/g" /root/.gitconfig && \
	sed -i "s/name =.*/name = ${NAME}/g" /root/.gitconfig && \
	echo "root:$PASSWD" | chpasswd

EXPOSE 22/tcp

ENTRYPOINT service ssh restart && zsh
