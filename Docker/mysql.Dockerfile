FROM ubuntu:20.04
RUN apt-get update \
     && apt install -y mysql-server \
     && sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mysql/mysql.conf.d/mysqld.cnf \
     && mkdir /var/run/mysqld \
     && chown -R mysql:mysql /var/run/mysqld
     
VOLUME ["/var/lib/mysql"]  
EXPOSE 3306     
CMD ["mysqld"]
