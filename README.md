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

check which exercises are available
```bash
ls 
```

navigate into the week/exercise you want to work on
```bash
cd week_xx
```

build the container and run it in detached mode
```bash
docker build -t linux-vm-lab .
docker run -d -p 8080:8080 --name student-vm linux-vm-lab
```
Note: In case you're connected to a metered internet connection, the first command will download larger files, hence might consume more of your data volume than expected.

connect to the container
```bash
docker exec -it student-vm /bin/bash
```
Now you are "connected" to the container as if you sshed into a remote VM.

Check the `task.md` file inside the week-folder for exercise specific instructions.

