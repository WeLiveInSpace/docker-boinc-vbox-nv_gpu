# docker-boinc-vbox-nv_gpu
This is still a WIP. The created docker image is large.

Tested on Ubuntu 20.04 host. Results may vary on other linux distros

This builds a docker image based on ubuntu 20.04 for boinc that allows for nvidia gpu and virtualbox passthrough

1. Ensure virtualbox, virtualbox-dkms, nvidia-container-toolkit  is installed on the host
2. clone repo
3. cd into repo root directory
4. Build the dockerfile

eg. 
```
docker build -t boinc-vbox-nvidia:20.04 /path/to/cloned/repository
```
5. Bring up the image using run

##Docker Run command template
Replace [...] with what you want

```
  sudo docker run -d \
    --name=[identifiable name for container] \
    --hostname [the name the BOINC project will use for the PC] \
    --device=/dev/vboxdrv `#allows access to host virtualbox`\
    -p 31416:31416 `#allows remote access to boinc`\
    --gpus all `#allows access to nvidia gpu through nvidia-toolbox`\
    --security-opt seccomp=unconfined `#not sure if required`\
    --privileged `#not sure if required`\
    -v [path/to/boinc/data/dir/]:/data `#local storage of boinc files. Can be empty initially`\
    -e TZ=[TZ] `#if no TZ specified BOINC will default to GMT`\
    --restart unless-stopped \
    boinc-vbox-nvidia:20.04
```




##Docker Run command example
```
  sudo docker run -d \
    --name=boinc \
    --hostname linuxbox_dockerImage_10-03-21_superV-s6_boinc-vbox-nvidia \
    --device=/dev/vboxdrv \
    -p 31416:31416 \
    --gpus all \
    --security-opt seccomp=unconfined \
    --privileged \
    -v /storage/opt/boinc:/data \
    -e TZ=America/Los_Angeles \
    --restart unless-stopped \
    boinc-vbox-nvidia:20.04
```
