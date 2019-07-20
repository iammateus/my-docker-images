#Sets base image
FROM ubuntu:18.04

#Updates apt-get packages
RUN apt-get update \
	#Installs nano
	&& apt-get install nano -y \
	#Installs nginx
	&& apt-get install nginx -y \
	#Installs tzdata
	&& apt-get install tzdata -y \
	#Sets São Paulo timezone
	&& ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
	#Reloads timezone
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	#Installs software-properties-common to be able to add ppa
	&& apt-get install software-properties-common -y \
	#Adds PPA (Personal Package Archives) of PHP FPM
	&& add-apt-repository ppa:ondrej/php -y \
	#Updates apt-get packages
	&& apt-get update \
	#Installs PHP 7.2 and most used packages
	&& apt-get install php7.2 php7.2-common php7.2-cli php7.2-fpm php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip php7.2-pgsql -y \
	#Installs curl
	&& apt-get install curl -y \
	#Download composer installer
	&& curl -s https://getcomposer.org/installer | php \
	#Moves composer to right location
	&& mv composer.phar /usr/local/bin/composer 

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