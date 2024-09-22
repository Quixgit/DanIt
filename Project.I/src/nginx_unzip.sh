#!/bin/bash

APP_USER="appuser"
APP_DIR="/home/$APP_USER"
PROJECT_DIR="/var/www/html/pets"
SITE_ARCHIVE="pets.zip"

install_packages() {
    echo "Установка необходимых пакетов: Nginx, Java JDK, Unzip..."
    sudo apt-get update
    sudo apt-get install -y nginx openjdk-11-jdk unzip
}

create_app_user() {
    echo "Создание пользователя $APP_USER..."
    sudo useradd -m -s /bin/bash $APP_USER
    echo "$APP_USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$APP_USER
}

#ПЕРЕДЕЛАТЬ к чертовой матери
copy_site_archive() {
    echo "Копирование архива сайта с локального хоста на сервер..."
    vagrant scp $SITE_ARCHIVE nginx:/var/www/html/pets  
}

# Функция для настройки Nginx
setup_nginx() {
    echo "Настройка Nginx..."
    sudo systemctl enable nginx
    sudo systemctl start nginx
    
    # Создание директории для сайта и распаковка архива
    echo "Создание директории для сайта и распаковка архива..."
    sudo mkdir -p $PROJECT_DIR
    sudo unzip $SITE_ARCHIVE -d $PROJECT_DIR
    echo "Настройка конфигурации Nginx..."
    # Настройка конфигурации Nginx для сайта
    sudo bash -c 'cat <<EOT > /etc/nginx/sites-available/pets
        server {
        listen 8080;
        server_name localhost;
        root /var/www/html/pets;
        index index.html;
        }
    EOT'
    
    sudo ln -s /etc/nginx/sites-available/pets /etc/nginx/sites-enabled/
    sudo rm /etc/nginx/sites-enabled/default
    sudo systemctl restart nginx
}

# Функция для настройки переменных окружения (если нужно)
set_environment_variables() {
    echo "Настройка переменных окружения..."
    sudo -u $APP_USER bash -c "echo 'export DB_HOST=${DB_HOST}' >> ~/.bashrc"
    sudo -u $APP_USER bash -c "echo 'export DB_USER=${DB_USER}' >> ~/.bashrc"
    sudo -u $APP_USER bash -c "echo 'export DB_PASS=${DB_PASS}' >> ~/.bashrc"
}

# Вызов функций
create_app_user
install_packages
copy_site_archive
setup_nginx
set_environment_variables
