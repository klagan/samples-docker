FROM nginx:1.17.1-alpine AS final

ENV SOME_ENV_VARIABLE= 

COPY startup.sh /

RUN chmod +x /startup.sh

CMD [ "/startup.sh" ]

# run the startup.sh to create the custom configuration file
# could probably pull the NGINX start up from the startup.sh to a CMD/ENTRYPOINT here
