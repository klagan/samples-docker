FROM nginx:latest

COPY etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

COPY etc/nginx/sites-available/ghost.local.conf /etc/nginx/conf.d/ghost.local.conf 

# RUN mkdir /etc/nginx/sites-available /etc/nginx/sites-enabled

# COPY etc/nginx/sites-available/ghost.local.conf /etc/nginx/sites-available/ghost.local.conf

COPY usr/share/ghost.local/index.html /usr/share/nginx/ghost.local/index.html

# RUN ln -s /etc/nginx/sites-available/ghost.local.conf /etc/nginx/sites-enabled/ghost.local.conf


