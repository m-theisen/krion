# Live Debugging

## Requirements
### Container Runtime/Docker
To run this lab locally you'll need a container runtime. Typically `docker` is used for this.
For MacOS or Windows it can be downloaded via the [official webpage](https://www.docker.com/products/docker-desktop/).
On Linux it is typically easier to just install the `docker` package via your official package manager.

Alternatives to Docker Desktop are:
- `podman`
- Rancher Desktop

### Git Client (optional)
You can download the archive version of this repository, but using a git-client makes it a hint simpler. You can download it on [this webpage](https://git-scm.com/install/).

### installation steps for Linux (Docker & Git)
for simplification, we will switch to root so as all subsequent commands are run initially under root context
```bash
sudo su -
```
#### 1. Update OS packages
```bash
dnf update -y
```
#### 2. Install Docker and Git
```bash
dnf install -y docker git
```
#### 3. Start & enable Docker service
```bash
systemctl start docker
systemctl enable docker
```

## Lab Preparation
Download the repo by running
```bash
git clone https://github.com/m-theisen/krion.git
```
or by clicking the green "Code" button and selecting "Download ZIP".

navigate to the folder where the repo got cloned
```bash
cd krion
```
build the container and run it in detached mode
```bash
docker build -t linux-vm-lab .
docker run -d -p 8080:8080 --name student-vm linux-vm-lab
#docker run --rm -p 8080:8080 --name student-vm linux-vm-lab
```
Note: In case you're connected to a metered internet connection, the first command will download larger files, hence might consume more of your data volume than expected.

connect to the container
```bash
docker exec -it student-vm /bin/bash
```
Now you are "connected" to the container as if you sshed into a remote VM.

## Task
Opening a browser on your local system and connecting to `http://127.0.0.1:8080` should produce the output `{"status": "success", "message": "Lab Completed! Service restored."}`. This won't be the case after starting this lab, because there are two bugs inside the container.

### Application Overview
The container runs a reverse proxy `nginx` which listens on port `8080` and proxies requests to a backend. In our case a very simple python application which runs as an unprivileged user.

## Instructions
The following steps will take you through the debugging journey. Ideally, don't look at the full solution at once but scroll down only once you entered the current command and understood what it did and what the output means.

All steps are executed inside the terminal where you ran the `docker exec ...` command and are connected to the container.

### Network Debugging

Check ngnix web server 
```bash
curl http://127.0.0.1:8080
```
this gives the result > Bad Gateway

Checking Nginx error logs:
```bash
cat /var/log/nginx/error.log
```

Inspect active open ports:
```bash
netstat -tlpn
```

Edit Nginx configuration (change port 5001 > 5000):
```
nano /etc/nginx/conf.d/default.conf
```
in nano you need to click the following buttons in the mentioned order so as to save and exit CTRL+X, Y, ENTER

Reload Nginx:
```bash
nginx -s reload
```

### Permission Debugging
Check ngnix web server
```bash
curl http://127.0.0.1:8080
```
This gives the result -> Internal Server Error

Inspect app error logs:
```bash
cat /var/log/api.err.log
```

Inspect file permissions:
```bash
ls -la /etc/app/app.conf
```

Fix permissions:
```bash
chmod 644 /etc/app/app.conf
```

### Final Check
```bash
curl http://127.0.0.1:8080
```

## Clean-Up
Stop the running container by running in a terminal on
your host machine
```bash
docker stop student-vm
```
or by stopping it in the Docker Desktop UI.
