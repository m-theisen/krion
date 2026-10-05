# Task
> [!CAUTION]
> You need to 

Opening a browser on your local system and connecting to `http://127.0.0.1:8080/fetch` should produce the output `{"data":"<Zen Quote from GitHub>","latency_seconds":0.05,"status":"success"}`. The `data` part will change over time, for us the most interesting part is the `latency_seconds` field. It should be around 0.05. This won't be the case after starting this lab, because there is a bug inside the container.

## Application Overview
The container runs a simple python application, which returns the output of `https://api.github.com/zen`, as an unprivileged user. The app is restarted automatically if it crashes or is killed.

# Instructions
The following steps will take you through the debugging journey. Ideally, don't look at the full solution at once but scroll down only once you entered the current command and understood what it did and what the output means.

Most steps are executed inside the terminal where you ran the `docker exec ...` command and are connected to the container.

## Latency Debugging

In a web-browser visit `http://127.0.0.1:8080/fetch`, it will take a while for it to load, be patient. After the page loads you can open the developer tools (press F12) and go to the `Network` tab. Reload the page again. Now you see (independently from the `latency_seconds` field in the response) how long the requests takes.

Now switching to the container, confirm the problem is on the "VM" and not the network connection between the "VM" and the browser
```bash
time curl -i http://127.0.0.1:8080/fetch
```
this returns a `real` time of about 5s.

It's always DNS, so check it first ;-)
```bash
time dig api.github.com
```
-> long wait time and `communications error to ...`
-> wrong/broken DNS server

Remove broken server from `/etc/resolv.conf`
```bash
nano /etc/resolv.conf
```
-> delete the line with `192.0.2.1`
-> save and exit (CTRL+O, ENTER, then CTRL+X)

The app needs to pick up the changes, we know it is automatically restarted when it stops, so we want to kill it.

Find process (ID)
```bash
ps aux
```
-> look for line with `/app/app.py`
-> note the `PID`

Kill the correct process
```bash
kill <PID>
```

## Final Check
Reload the tap in the browser and check how long the call takes.

# Clean-Up
Stop the running container by running in a terminal on
your host machine
```bash
docker stop student-vm
```
or by stopping it in the Docker Desktop UI.

