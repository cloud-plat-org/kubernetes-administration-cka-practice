#! /bin/bash

# Docker Storage

#   Storage Drivers  &  Volume Drivers

### Docker Storage Drivers:
#  This is where docker stores the data by default.
 sudo ls -al /var/lib/docker/
# total 52
# drwx--x--- 12 root root 4096 Oct 28 13:56 .
# drwxr-xr-x 37 root root 4096 Oct 28 14:26 ..
# drwx--x--x  3 root root 4096 Oct  4 03:34 buildkit
# drwx--x---  4 root root 4096 Oct 11 22:03 containers
# -rw-------  1 root root   36 Oct  4 03:34 engine-id
# drwx------  3 root root 4096 Oct  4 03:34 image
# drwxr-x---  3 root root 4096 Oct  4 03:34 network
# drwx--x---  9 root root 4096 Oct 28 13:56 overlay2
# drwx------  3 root root 4096 Oct  4 03:34 plugins
# drwx------  2 root root 4096 Oct 28 13:56 runtimes
# drwx------  2 root root 4096 Oct  4 03:34 swarm
# drwx------  3 root root 4096 Oct 31 14:57 tmp
# drwx-----x  3 root root 4096 Oct 28 13:56 volumes

# Layered Architecture
# dockerfile
From: ubuntu
Run: apt-get update && apt-get -y install python
Run: pip install flask flask-mysql
COPY . /opt/source-code
ENTRYPOINT: FLASK_APP=/opt/source-code/app.py flask run

docker build Dockerfile -t mmushad/my-custom-app
# layer 1. Base Ubuntu layer  (120MB)
# layer 2. Changes in apt packages layer (306MB)
# Layer 3. Changes in pip packages layer (6.3MB)
# Layer 4. Source code (229 B)
# Layer 5. Update Entrypoint (0  B)

# dockerfile
From: ubuntu
Run: apt-get update && apt-get -y install python
Run: pip install flask flask-mysql
COPY app2.py /opt/source-code
ENTRYPOINT: FLASK_APP=/opt/source-code/app2.py flask run

docker build Dockerfile -t mmushad/my-custom-app2
# Layer 1. Not built again, same as previous image.
# Layer 2. Not built again, same as previous image.
# Layer 3. Not built again, same as previous image.
# Layer 4. Source code (229 B)
# Layer 5. Update Entrypoint (0  B)

# This way docker builds images faster and more efficiently.
# if you were to update your app.py, it would use that existing layers and only use the changes to rebuild images.

# Docker Container layers:
# Layer 6. Container layer (100MB) (read/write layer)
docker run -d mmushad/my-custom-app
# Docker Image layers:
# Layer 5. Update Entrypoint (0  B)
# Layer 4. Source code (229 B)
# Layer 3. Changes in pip packages layer (6.3MB)
# layer 2. Changes in apt packages layer (306MB)
# layer 1. Base Ubuntu layer  (120MB)
docker build Dockerfile -t mmushad/my-custom-app
# once built they are read only.

# When the container is deleted, everything in the container layer is deleted with it.

# How do we make data persistent?
# first create a volume.
docker volume create my-volume
# then mount the volume to the container.
# /var/docker/volumes/my-volume

docker run -v my-volume:/var/lib/mysql mysql # docker volume create before this command.
# -v is the volume flag.
# my-volume is created volume
# /var/lib/mysql is the directory in the container that the volume is mounted to.
# mysql is the image name.
#|________________ docker host __________|
docker run -v my-volume2:/var/lib/mysql mysql2 # NO docker volume create before this command.
# my-volume2 is created volume
# /var/lib/mysql is the directory in the container that the volume is mounted to.
# mysql2 is the image name.
#|________________ docker host __________|

#These can be seen in the /var/lib/docker/volumes directory.
####### above is called volume mounting. #######

# What if we already have data on external storage but mouted to the host?
# and if we don't want to mount it in the default directory /var/lib/mysql?
####### Bind Mounting: #######

docker run -v /data/mysql:/var/lib/mysql mysql # volume mount is persistent.
# /data/mysql is the directory on the docker host that the volume is mounted to.
# /var/lib/mysql is the directory in the container that the volume is mounted to.
# mysql is the image name.
#|________________ docker host __________|

docker run \
  --mount type=bind,source=/data/mysql,target=/var/lib/mysql \
  mysql

# It is the `storage drivers` that are responsible for:
# maintaining the Layered Architecture
# Creating a writeable layer
# Moving data between layers
# Deleting the container layer

# Common Storage Drivers:
# Overlay
# Overlay2
# AUFS - Available on Ubunto but not on Eudora, CentOS.
# Devicemapper - Available on Eudora, CentOS.
# Btrfs
# ZFS
# VFS

### Docker Volume Drivers:

# Local
# Auzure File Storage
# Convoy
# DigitalOcean Block Storage
# Flocker
# gce-docker
# GlusterFS
# NetApp
# NFS
# EBS
# EFS
# Rexray (AWS EBS, EFS, Stoarge Array (Isolon, ScaleIO, Google Persistent Disks Open Stack ?))
# Portworx
# VMware vSphere Storage

docker run -it \
  --volume-driver rexray/ebs
  --mount src=ebs-volume,target=/var/lib/mysql \
  mysql
# When running this command you can specify the volume driver to use.

### Container Storage Interface (CSI)








