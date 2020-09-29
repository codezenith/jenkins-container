# jenkins-container
Jenkins containerized

## Build and execute

Build the container with:

```
docker build -t jenkins:latest --build-arg KST_PASS="<Your Keystore Password>" .
```

First time running, create a docker volume:

```
docker volume create jenkins-data
```

Start the container with:

```
docker run -d --name jenkins -p 443:443 -v jenkins-data:/var/jenkins_home jenkins:latest
```

## Install docker and certificates
To build the container with docker (dind) run

```
docker build -t jenkins:latest --build-arg KST_PASS="<Your Keystore Password>" --build-arg DOCKER="true" .
```

To additionally push the certificates (e.g.: `your-company.crt` placed in `cacerts/`) into the docker trusted certificate chain build with:

```
docker build -t jenkins:latest --build-arg KST_PASS="<Your Keystore Password>" --build-arg DOCKER="true" --build-arg CERT="true" .
```
This command will copy your `*.crt` file into `/usr/local/share/ca-certificates/`

The above steps are combinable in any way you like.
___
__NOTE:__ When building jenkins with the docker in docker feature, you have to run jenkins with the host socket as a volume:

```
docker run -d --name jenkins -p 443:443 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins-data:/var/jenkins_home jenkins:latest
```
___

## Monitoring

Watch the container logs with:

```
docker logs jenkins -f
```
