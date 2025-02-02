# Usage
# docker build -f=nodedev.Dockerfile -t=nvimnode:v0.1 --build-arg=EMAIL={{YOUR_EMAIL}} --build-arg=NAME={{YOUR_NAME}} --build-arg=PASSWD={{YOUR_PASSWD}} .
# docker run -v ~/workspace/{{YOUR-PROJECT}}:/root/workspace/{{YOUR-PROJECT}} -p 8654:22 --name {{IMAGE_NAME}} -d -it nvimnode:v0.1
# ssh user@<hostname> -p 8654 -t "tmux new -s {{TMUX_SESSION}}" for the first time, and
# ssh user@<hostname> -p 8654 -t "tmux a -t {{TMUX_SESSION}}"

# ubuntu 20.04
FROM ubuntu:focal-20240216 
WORKDIR /root

ARG EMAIL
ARG NAME
ARG PASSWD=root
ARG TZ=Etc/UTC

ENV EMAIL=$EMAIL
ENV NAME=$NAME
ENV PASSWD=$PASSWD
ENV TZ=$TZ

# Install things
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y git openssh-server && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
	git clone https://github.com/rickliujh/dotfiles.git && \
	cd ./dotfiles && \
	bash setup.sh install_without_languages && \
	bash setup.sh backup_configs && \
	bash setup.sh setup_symlinks && \
	bash setup.sh install_dev_pkgs && \
	curl -fsSL "https://deb.nodesource.com/setup_lts.x" | bash - && apt-get install -y nodejs && \
	corepack enable && \
	rm -rf setup_lts.x && \
	apt-get clean
	
# Setup SSH and git
RUN sed -i'' -e's/^#PermitRootLogin prohibit-password$/PermitRootLogin yes/' /etc/ssh/sshd_config && \
        sed -i'' -e's/^#PasswordAuthentication yes$/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
        sed -i'' -e's/^#PermitEmptyPasswords no$/PermitEmptyPasswords yes/' /etc/ssh/sshd_config && \
        sed -i'' -e's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
	mkdir -p /root/workspace && \
	echo "[user]\n \
    name = $NAME\n \
    email = $EMAIL\n \
    signingkey = ~/.ssh/id_ed25519.pub\n \
" >> /root/workspace/.gitconfig-default && \
	echo "root:$PASSWD" | chpasswd

EXPOSE 22/tcp

ENTRYPOINT service ssh restart && zsh
