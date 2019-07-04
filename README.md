# VooThanhDock



## Local build
+ Update config on .env file.



## Use image on hub
+ Copy `docker-compose.yml.sample` to root folder of project.
+ Rename `docker-compose.yml.sample` to `docker-compose.yml`.
+ Update config for each service.



## Config

### Nginx
- NGINX_CONFIG
    + Update custom config for nginx
    + Syntax: key=value
    + The key-value pairs ​​are separated by space or new line if using sample file.
- SERVER_NAME
    + Global server name on vhost.
- PHP_SERVICE
    + PHP service name on docker-compose (defaul: php)
- PHP_PORT
    + PHP port on php service. (default: 9000)
- ROOT_FOLDER
    + Project path on container (default: /project)
- IS_HTTPS
    + Value: true \ false
    + Whether to use https or not
- IS_MAGENTO
    + Value: true \ false
    + Is project magento
- IS_MAGENTO_MULTI
    + Value: true \ false
    + Is magento multi store
    + Only work if is_magento = true
- MAGENTO_MODE
    + Value: developer \ default \ production
    + Magento mode running
    + Only work with magento multi store
- MAGENTO_RUN_TYPE
    + Value: store \ website
    + Magento multi store type
    + Only work with magento multi store
- MAGENTO_MULTI_SITES= # server_name1=store_code1 or website_code1;server_name2=store_code2 or website_code2 ...
    + Syntax: server_name=code
    + Code = store code or website code
    + The server_name-code pairs ​​are separated by ;
- If using docker-compose for many projects
    + `SERVER_NAME`, `IS_HTTPS`, `IS_MAGENTO`, `IS_MAGENTO_MULTI`, `MAGENTO_MODE`, `MAGENTO_RUN_TYPE`, `MAGENTO_MULTI_SITES`: 
    value for each project is separated by space
    
### PHP
- IS_ACTIVE_XDEBUG
    + Value: true \ false
    + Enable xdebug
- ENABLE_SENDMAIL
    + Value: true \ false
    + Enable send email
- ENABLE_CRON
    + Value: true \ false
    + Enable cron job
- CONFIG
    + Add php custom config
    + Syntax: key=value
    + The key-value pairs ​​are separated by space or new line if using sample file.
- POOL
    + Add php pool custom config
    + Syntax: key=value
    + The key-value pairs ​​are separated by space or new line if using sample file.
