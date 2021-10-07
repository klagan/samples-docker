# Sonarqube parent image

This `Dockerfile` installs all the components for `Sonarqube scanner` to function.  You could use this as the basis of a parent `build` image, where we install things like `dotnet`, `az cli` and other build tools.

When we create a `child build image` we would inherit from this image and inject the following properties and call the `Sonarqube scanner` as here:

```
ARG SONARQUBE_PROJECT_URL= 
ARG SONARQUBE_PROJECT_KEY=    
ARG DEBIAN_FRONTEND=noninteractive

RUN mkdir -p /app

WORKDIR /app

# do your build here

# run sonar statistics (SCA)
RUN if [ -n "${SONARQUBE_PROJECT_URL}" ] ; \
  then /opt/sonar-scanner/bin/sonar-scanner \
  -Dsonar.projectKey=${SONARQUBE_PROJECT_KEY} \
  -Dsonar.sources=. \
  -Dsonar.host.url=${SONARQUBE_PROJECT_URL};\
  else echo "No SonarQube URL provided"; fi 
```
