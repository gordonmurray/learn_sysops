FROM ubuntu:18.04  
RUN apt-get update && apt-get install -y apache2  
ENV APACHE_RUN_USER www-data  
ENV APACHE_RUN_GROUP www-data  
ENV APACHE_LOG_DIR /var/log/apache2  
ENV APACHE_RUN_DIR /var/www/html/  
EXPOSE 8080  
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 