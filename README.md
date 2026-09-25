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


## Lab Preparation
Download the repo by running
```bash
git clone ...
```
or by clicking the green "Code" button and selecting "Download ZIP".

Open a terminal and run:
```bash
docker build -t linux-vm-lab .
docker run --rm -p 8080:8080 --name student-vm linux-vm-lab
```
Note: In case you're connected to a metered internet connection, the first command will download larger files, hence might consume more of your data volume than expected.

In a second terminal run:
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

Start: Run `curl http://127.0.0.1:8080` -> Bad Gateway

Checking Nginx error logs:
```bash
cat /var/log/nginx/error.log
```

Inspect active open ports:
```bash
netstat -tlpn
```

Edit Nginx configuration:
```
nano /etc/nginx/conf.d/default.conf
```

Reload Nginx:
```bash
nginx -s reload
```

### Permission Debugging

Start: Run `curl http://127.0.0.1:8080` -> Internal Server Error

Inspect app error logs:
```bash
cat /var/log/api.err.log
```

Inspect file permissions:
```bash
ls -la /etx/app/app.conf
```

Fix permissions:
```bash
chmod 644 /etc/app/app.conf
```

### Final Check

Run `curl http://127.0.0.1` -> expected answer

