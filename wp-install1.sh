!/bin/bash 
clear
echo -n "Database Host : "
read dbhost
echo -n "Database Name : "
read dbname
echo -n "Database User : "
read dbuser
echo -n "Database Password : "
read dbpass
echo
echo -n "Site url : "
read siteurl
echo -n "Site Name : "
read sitename
echo -n "Email Address : "
read wpemail
echo -n "Admin User Name : "
read wpuser
echo -n "Admin User Password : "
read wppass
echo -n "run install? (y/n) : "
read run
if [ "$run" == n ] ; then
exit

else
echo
yum update -y
yum install httpd php php-mysql -y
echo "healthy" > healthy.html
wget https://wordpress.org/wordpress-5.1.1.tar.gz
tar -xzf wordpress-5.1.1.tar.gz
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf wordpress-5.1.1.tar.gz
chmod -R 755 wp-content
chown -R apache:apache wp-content
wget https://s3.amazonaws.com/bucketforwordpresslab-donotdelete/htaccess.txt
mv htaccess.txt .htaccess
chkconfig httpd on
service httpd start
echo

cp wp-config-sample.php wp-config.php

perl -pi -e "s/localhost/$dbhost/g" wp-config.php
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

mkdir wp-content/uploads
chmod 777 wp-content/uploads
echo
echo "Installing wordpress..."
php wp core install --allow-root --url="$siteurl" --title="$sitename" --admin_user="$wpuser" --admin_password="$wppass" --admin_email="$wpemail"
fi

