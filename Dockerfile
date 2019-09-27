#Sets base image
FROM ubuntu:18.04

#Updates apt-get packages
RUN apt-get update \
	#Installs nano
	&& apt-get install nano -y \
	#Installs tzdata
	&& apt-get install tzdata -y \
	#Sets São Paulo timezone
	&& ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
	#Reloads timezone
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	#Installs curl
	&& apt-get install curl -y \
	#Gets nodejs package with curl
	&& curl -sL https://deb.nodesource.com/setup_12.x | bash \
	#Installs nodejs
	&& apt-get install nodejs -y

#Opens /var/www/html
WORKDIR /var/www/html

#Copies startup.sh file from host to root directory
COPY startup.sh /

#Gives execution permission
RUN chmod 777 /startup.sh

#Exposes ports
EXPOSE 3000

#Sets default command when container initiates 
CMD ["/startup.sh"]