# jenkins-container
Jenkins containerized

## Build and execute

Build the container with:

```
docker build -t jenkins:latest .
```

First time running, create a docker volume:

```
docker volume create jenkins-data
```

Start the container with:

```
docker run -d --name jenkins -p 443:443 -v jenkins-data:/var/jenkins_home jenkins:latest
```


## Monitoring

Watch the container logs with:

```
docker logs jenkins -f
```
