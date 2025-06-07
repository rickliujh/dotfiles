
# Dockerfile For Remote Development                     #

> [!warning]
> For security reason, you should only use it in local environment and do not upload
> to any public registery, bacause the PASSWD is exposed in the final image. Be aware
> of the risk if doing so.

## Base Image 

### Includes

1. all non-language specific tools for development from dotfiles
2. a SSH server with proper configuration for connecting remotely with tmux
3. proper gitconfig for open-box usage

### Build

```
docker build -f=Dockerfile.base -t=devbase:v0.1 --build-arg EMAIL={{YOUR_EMAIL}} --build-arg USER={{YOUR_NAME}} --build-arg PASSWD={{YOUR_PASSWD}} .

```

### Run

```
docker run -v $(echo ~)/workspace/{{YOUR-PROJECT}}:/root/workspace/{{YOUR-PROJECT}} -p 8654:22 --name {{IMAGE_NAME}} -d -it devbase:v0.1

ssh user@<hostname> -p 8654 -t "tmux a -t {{TMUX_SESSION}}"

# for the first time
ssh user@<hostname> -p 8654 -t "tmux new -s {{TMUX_SESSION}}" 

```

###  Docker in Docker:

```
docker build -f=Dockerfile.base -t=devbase:v0.1 --build-arg BASEIMAGE=cruizba/ubuntu-dind:latest --build-arg EMAIL={{YOUR_EMAIL}} --build-arg NAME={{YOUR_NAME}} --build-arg PASSWD={{YOUR_PASSWD}} .
```

#### Unsafe way (not suggest)

```
docker run --privileged -v $(echo ~)/workspace/{{YOUR-PROJECT}}:/root/workspace/{{YOUR-PROJECT}} -p 8654:22 --name {{IMAGE_NAME}} -d -it devbase:v0.1
```
#### Safe way (with sysbox)

```
docker run --runtime=sysbox-runc -v $(echo ~)/workspace/{{YOUR-PROJECT}}:/root/workspace/{{YOUR-PROJECT}} -p 8654:22 --name {{IMAGE_NAME}} -d -it devbase:v0.1

# install sysbox: 
bash setup.sh install_sysbox
```

### Resources:
- https://github.com/nestybox/sysbox?tab=readme-ov-file#installing-sysbox
- https://github.com/nestybox/sysbox/blob/master/docs/user-guide/dind.md
- https://www.docker.com/resources/docker-in-docker-containerized-ci-workflows-dockercon-2023
- https://github.com/cruizba/ubuntu-dind?tab=readme-ov-file#3-usage-guide
