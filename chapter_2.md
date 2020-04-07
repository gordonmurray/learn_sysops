### Sample Vagrant file

```
Vagrant.configure("2") do |config| 
  config.vm.box = "bionic64" 
  config.vm.hostname = "bionic.box" 
  config.vm.network :private_network, ip: "192.168.0.10" 
end 
```

### Sample Dockerfile

```
FROM ubuntu:18.04  
RUN apt-get update && apt-get install -y apache2  
ENV APACHE_RUN_USER www-data  
ENV APACHE_RUN_GROUP www-data  
ENV APACHE_LOG_DIR /var/log/apache2  
ENV APACHE_RUN_DIR /var/www/html/  
EXPOSE 8080  
CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"] 
```
