#! /bin/bash

sitename=$1

echo "creating $sitename in www dirrectory\n"
mkdir www/$sitename
touch www/$sitename/index.php
echo "<?php phpinfo(); ?>" > www/$sitename/index.php
echo "site created\n"

echo "configurating nginx\n"
touch hosts/$sitename.conf
printf "`
`server {\n`
`    listen 80;\n`
`    listen [::]:80;\n`
`    index index.php;\n`
`    server_name $sitename;\n`
`    error_log  /var/log/nginx/error.log;\n`
`    access_log /var/log/nginx/access.log;\n`
`    root /var/www/$sitename;\n`
`\n`
`    location ~ \.php$ {\n`
`        try_files \$uri =404;\n`
`        fastcgi_split_path_info ^(.+\.php)(/.+)$;\n`
`        fastcgi_pass php:9000;\n`
`        fastcgi_index index.php;\n`
`        include fastcgi_params;\n`
`        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\n`
`        fastcgi_param PATH_INFO \$fastcgi_path_info;\n`
`    }\n`
`}\n`
`" > hosts/$sitename.conf
echo "completed"
