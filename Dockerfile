#Sets base image
FROM ubuntu:18.04

#Updates apt packages
RUN apt update \
	#Installs nano
	&& apt install nano -y \
	#Installs nginx
	&& apt install nginx -y \
	#Installs software-properties-common to be able to add ppa
	&& apt install software-properties-common -y \
	#Adds PPA (Personal Package Archives) of PHP FPM
	&& add-apt-repository ppa:ondrej/php -y \
	#Updates apt packages
	&& apt update \
	#Installs PHP 7.2 and most used packages
	&& apt install php7.2 php7.2-common php7.2-cli php7.2-fpm -y \
	#Sets São Paulo timezone
	&& ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
	#Reloads timezone
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	#Deletes HTML index file
	&& rm index.nginx-debian.html

#Opens /etc/nginx directory
WORKDIR /etc/nginx/

#Copies nginx.conf file from host to current image directory 
COPY nginx.conf nginx.conf

#Opens /etc/nginx/sites-enabled directory
WORKDIR /etc/nginx/sites-enabled

#Copies app file from host to current image directory
COPY app app 

#Opens /var/www/html directory
WORKDIR /var/www/html

#Copies index.php file from host to current image directory
COPY index.php index.php

#Deletes default nginx index file
RUN rm index.nginx-debian.html

#Copies startup.sh file from host to root directory
COPY startup.sh /

#Gives execution permission
RUN chmod 777 /startup.sh

#Exposes ports
EXPOSE 8080 80 443

#Sets default command when container initiates 
CMD ["/startup.sh"]