#!/bin/bash

DB_USER=${DB_USER:-"petclinic"}
DB_PASS=${DB_PASS:-"petclinic"}
DB_NAME=${DB_NAME:-"petclinic"}
#DB_SUBNET=${DB_SUBNET:-"192.168.56.0/24"}


sudo apt-get update
sudo apt-get install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql


sudo sed -i "s/bind-address.*/bind-address = 192.168.56.10/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo systemctl restart mysql

sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH 'vagrantpass BY 'root';"

# Создаем базу данных, пользователя и предоставляем права
mysql -uroot -proot <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'192.168.56.11' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'192.168.56.11';
FLUSH PRIVILEGES;
EOF

sudo systemctl restart mysql

echo "MySQL настроен успешно."
echo "Пользователь: ${DB_USER}, База данных: ${DB_NAME}, Пароль: ${DB_PASS}"
