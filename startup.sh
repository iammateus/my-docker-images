#!/bin/bash

service nginx start;
service php7.2-fpm start;
chmod 777 /var/run/php/php7.2-fpm.sock
/bin/bash;