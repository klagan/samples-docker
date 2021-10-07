# Getting started

This image will have build tools to build code e.g. aspnetcore project, npm project etc

# TODO:: example of running image with ARG/ENV

To run the sonar scanner we need to call:

```
# run sonar statistics (SCA)
RUN if [ -n "$SONARQUBE_PROJECT_URL" ] ; \
  then /opt/sonar-scanner/bin/sonar-scanner \
  -Dsonar.projectKey=${SONARQUBE_PROJECT_KEY} \
  -Dsonar.sources=. \
  -Dsonar.host.url=${SONARQUBE_PROJECT_URL};\
  else echo "No SonarQube URL provided"; fi 
```
