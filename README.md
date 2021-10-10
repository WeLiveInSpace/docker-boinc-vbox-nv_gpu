# docker-boinc-vbox-nv_gpu
This is still a WIP. The created docker image is large.

Tested on Ubuntu 20.04 host. Results may vary on other linux distros

This builds a docker image based on ubuntu 20.04 for boinc that allows for nvidia gpu and virtualbox passthrough

1. Install nvidia base drivers on host if not already present (recommend a reboot afterwards)
2. Install  virtualbox, virtualbox-dkms, nvidia-container-toolkit on host if not already present (recommend a reboot afterwards)
3. clone repo
4. cd into repo root directory
5. Build the dockerfile

eg. 
```
docker build -t boinc-vbox-nvidia:20.04 /path/to/cloned/repository
```
6. Bring up the image using run

## Docker Run command template
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




## Docker Run command example
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

## Tips
To access BOINC remotely ensure the following files are present in BOINC's data directory. This can be done before the initial docker run or afterwards.

The docker container may need to be restarted to pick up the new configuration

1. gui_rpc_auth.cfg <-- The password you want to use to access boinc remotely
```
boinc_password
```
2. remote_hosts.cfg <-- file contains a list of hostnames or IP addresses (one per line) of remote hosts, that are allowed to connect and to control BOINC
```
#client 1 using hostname
host.example.com

#client 2 using ip
192.168.0.180
```
