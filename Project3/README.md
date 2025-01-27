Вот полный текст для файла README.md, который вы можете скопировать и вставить в свой репозиторий на GitHub.

# Проект для развертывания Jenkins на AWS с помощью Terraform и Ansible

## Описание

Данный проект предназначен для автоматизации развертывания Jenkins CI/CD на платформе AWS, используя Terraform для управления инфраструктурой и Ansible для настройки приложений. Проект включает в себя создание виртуальной частной сети (VPC), EC2 инстансов для Jenkins и конфигурацию веб-сервера Nginx в качестве обратного прокси для Jenkins.

## Структура проекта

```plaintext
project/
│
├── terraform/
│   ├── main.tf            # Основной файл конфигурации Terraform
│   ├── variables.tf       # Определение переменных
│   ├── outputs.tf         # Вывод значений
│   └── providers.tf       # Настройка провайдеров
│
├── ansible/
│   ├── install_jenkins.yml # Ansible плейбук для установки Jenkins
│   └── templates/
│       └── nginx.conf.j2   # Шаблон конфигурации Nginx
│
└── README.md               # Документация по проекту

Требования

Перед началом работы, убедитесь, что у вас установлены следующие инструменты:

•	Terraform (версия 1.0 или выше)

•	Ansible (версия 2.9 или выше)

•	AWS CLI с настроенными аккредитивами

•	SSH-клиент для подключения к EC2 инстансам

Настройка

Шаг 1: Клонирование репозитория

Клонируйте репозиторий на вашу локальную машину:

git clone <URL_вашего_репозитория>
cd project

Шаг 2: Настройка AWS

1.	AWS CLI: Убедитесь, что AWS CLI настроен с правильными учетными данными:

aws configure

2.	Создайте ключ доступа SSH: Если у вас нет SSH-ключа для подключения к EC2 инстансам, создайте его:

ssh-keygen -t rsa -b 2048 -f ~/.ssh/your_ssh_key

Шаг 3: Развертывание инфраструктуры с Terraform

1.	Перейдите в директорию terraform:

cd terraform

2.	Инициализируйте Terraform, чтобы загрузить необходимые плагины:

terraform init

3.	Проверьте план развертывания:

terraform plan

4.	Примените конфигурацию Terraform для создания AWS ресурсов:

terraform apply

•	Подтвердите процесс, введя yes, когда будет предложено.

5.	После успешного выполнения команды, запомните публичный IP адрес Jenkins master, который будет выведен в терминале.

Шаг 4: Настройка Jenkins с Ansible

1.	Убедитесь, что файл install_jenkins.yml настроен правильно и указывает на ваш инстанс Jenkins master.

2.	Создайте файл hosts.ini с информацией о ваших инстансах:

[jenkins_master]
<публичный_ip_jenkins_master> ansible_ssh_private_key_file=~/.ssh/your_ssh_key

[jenkins_worker]
<публичный_ip_jenkins_worker> ansible_ssh_private_key_file=~/.ssh/your_ssh_key

•	Замените <публичный_ip_jenkins_master> и <публичный_ip_jenkins_worker> на соответствующие значения.

3.	Запустите Ansible плейбук для установки Jenkins и Nginx:

ansible-playbook -i hosts.ini ansible/install_jenkins.yml

•	Ansible автоматически установит необходимые пакеты и настроит Jenkins на вашем инстансе.

Шаг 5: Доступ к Jenkins

1.	Откройте веб-браузер и введите следующий адрес:

http://<публичный_ip_jenkins_master>:80

2.	При первом доступе к Jenkins вам может потребоваться ввести первоначальный пароль. Получите его, выполнив команду SSH на Jenkins мастер:

ssh -i ~/.ssh/your_ssh_key ubuntu@<публичный_ip_jenkins_master>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

3.	После чего следуйте инструкциям для завершения первичной настройки Jenkins.

Завершение

Чтобы удалить все созданные ресурсы и избежать дополнительных затрат, выполните следующую команду в директории terraform:

terraform destroy

•	Подтвердите процесс, введя yes.


