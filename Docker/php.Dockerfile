FROM centos:8

#INTALL PHP
EXPOSE 80
RUN dnf install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf module enable -y php:remi-7.4 && \
    dnf install -y php php-opcache php-gd php-curl php-mysqlnd php-cli php-zip php-json && \
    yum -y install git && \
#COMPOSER
    curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer && \
#MANTISBT
    git clone https://github.com/mantisbt/mantisbt.git && \
    cd mantisbt && composer install 
 CMD [ "php", "-S", "0.0.0.0:80", "-t", "/mantisbt"]  

  
