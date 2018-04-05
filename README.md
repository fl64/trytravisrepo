# Table of content



- [Table of content](#table-of-content)
- [4. Homework-4: Intro in GCP](#4-homework-4-intro-in-gcp)
    - [4.1 Description](#41-description)
    - [4.2 Homework](#42-homework)
    - [4.3 Additional homework](#43-additional-homework)
- [5. Homework-5: Deploy if the test app](#5-homework-5-deploy-if-the-test-app)
    - [5.1 Description](#51-description)
    - [5.2 What was done](#52-what-was-done)
    - [5.3 Description of startup parameters](#53-description-of-startup-parameters)
    - [5.4 How to check](#54-how-to-check)
    - [5.5 How do remove](#55-how-do-remove)
- [6. Homework-6: Packer](#6-homework-6-packer)
    - [6.1 What was done](#61-what-was-done)
    - [6.2 How to run the project](#62-how-to-run-the-project)
        - [6.2.1 hw6-Base](#621-hw6-base)
        - [6.2.2 hw6--](#622-hw6)
    - [6.3 How to check](#63-how-to-check)
- [7. Homework-7: Terraform](#7-homework-7-terraform)
    - [7.1 What was done](#71-what-was-done)
    - [7.2 How to run the project](#72-how-to-run-the-project)
    - [7.3 How to check](#73-how-to-check)
- [8. Homework-8: Terraform-2](#8-homework-8-terraform-2)
    - [8.1 What was done](#81-what-was-done)
    - [8.2 Brief description of the solution ](#82-Brief-description-of-the-solution)
    - [8.3 How to run the project](#83-how-to-run-the-project)
    - [8.4 How to check](#84-how-to-check)
- [9. Homework-9: Ansible-1](#9-homework-9-ansible-1)
    - [9.1 What was done](#91-what-was-done)
    - [9.2 How to run the project](#92-how-to-run-the-project)
    - [9.3 How to check](#93-how-to-check)

# 4. Homework-4: Intro in GCP

## 4.1 Description

bastion_IP = 35.204.252.224

someinternalhost_IP = 10.164.0.3

Детальное описание:

- Host: bastion
    - Ext ip: 35.204.252.224
    - Int ip: 10.164.0.2

- Host: someinternalhost
    - Ext ip: none
    - Int ip: 10.164.0.3

## 4.2 Homework

> Исследовать способ подключения к someinternalhost в одну команду из вашего рабочего устройства,  проверить работоспособность найденного решения и внести его в README.md
> в вашем репозитории

Варианты выполнения:

```shell
ssh -i ~/.ssh/appuser -A -t appuser@35.204.252.224 ssh 10.164.0.3
```
Результат:

![](https://i.imgur.com/eB8WmVF.png)

```shell
ssh -i ~/.ssh/appuser -J appuser@35.204.252.224 appuser@10.164.0.3
```
Результат:

![](https://i.imgur.com/Uq5WydF.png)

## 4.3 Additional homework

> **Доп. задание: ** Предложить вариант решения для подключения из консоли при помощи команды вида ssh internalhost из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу internalhost и внести его в README.md в вашем репозитории

Добавиьт следующие варианты в ~/.ssh/config

```
Host bastion
    HostName 35.204.252.224
    User appuser
    Port 22
    ForwardAgent yes
    AddKeysToAgent yes
    IdentityFile ~/.ssh/appuser

Host someinternalhost
    User appuser
    Hostname 10.164.0.3
    Port 22
    ProxyJump bastion
    ForwardAgent Yes

```

Проверка:
```shell
ssh someinternalhost
```

Результат:

![](https://i.imgur.com/abzl05D.png)

# 5. Homework-5: Deploy if the test app

## 5.1 Description

testapp_IP = 35.204.89.147

testapp_port = 9292

## 5.2 What was done
- перенесены скритпы установки и конфиги VPN в каталог VPN
- созданы скрипты установки и настройки приложения (install_rubby.sh, install_mongodb.sh, deploy.sh)
- создан скрипт startup.sh для автоматической установки и настройки приложения при развертывании VM
- Создана VM reddit-app
- Назначен статический-ip

## 5.3 Description of startup parameters

Перейти в корень репозитория fl64_infra.

Создание VM:
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=startup.sh
```

или

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure
  --metadata startup-script-url=https://gist.githubusercontent.com/fl64/e1b838ebe8e142d449ef4435e7a43ff7/raw/676c9fe32b17541a63b80398779ec1bf42fa5bbb/startup.sh

```

Создание правил МЭ:
```
gcloud compute firewall-rules create default-puma-server \
  --allow=tcp:9292 \
  --target-tags=puma-server \
  --description="Allow access to puma server"
```


## 5.4 How to check

В веб-браузере перейти по адресу http://35.204.89.147:9292, в окне браузера отобразится интерфейс приложения.

## 5.5 How do remove

Удаление VM
```
gcloud compute instances delete reddit-app
```

Удаление правила МЭ
```
gcloud compute firewall-rules delete default-puma-server

```

# 6. Homework-6: Packer
## 6.1 What was done
- созданные в hw6 скрипты перенесены в каталог config-scripts
- создан каталог packer для шаблона ubuntu16.json и подкаталог scripts для скриптов установки сервисов и приложений
- в соотвествии с заданием параметризованы переменные создания шаблона ВМ

В рамках задания со *:
- создан шабаблон ВМ reddit-full (packer/immutable.json)
- создан скрипт packer/scripts/deploy.sh для деплоя приложения
- создан скрипт запуска ВМ (config-scripts/create-reddit-vm.sh)

## 6.2 How to run the project
### 6.2.1 hw6-Base
- Запустить создание шаблона:
```
cd packer
packer validate ubuntu16.json
packer build ubuntu16.json
```
доп задание:
```
cd packer
packer validate \
       -var 'prj_id=infra-198313' \
       -var 'src_img_fam=ubuntu-1604-lts' \
       ubuntu16.json
packer build \
       -var 'prj_id=infra-198313' \
       -var 'src_img_fam=ubuntu-1604-lts' \
       ubuntu16.json

или

packer validate -var-file=variables.json ubuntu16.json
packer build -var-file=variables.json ubuntu16.json
```
- Создать правила для МЭ (если отсуствуют)
```
gcloud compute firewall-rules create default-puma-server \
  --allow=tcp:9292 \
  --target-tags=puma-server \
  --description="Allow access to puma server"
```
- Создать ВМ:
![](https://i.imgur.com/1gVdBKJ.png)
- Задеплоить приложение
```
cd
ssh appuser@35.204.252.224 "bash -s" < config-scripts/deploy.sh
```
- Done!

### 6.2.2 hw6-*

- Запустить создание шаблона:
```
cd packer
packer validate -var 'prj_id=infra-198313' -var 'src_img_fam=ubuntu-1604-lts' immutable.json
packer build -var 'prj_id=infra-198313' -var 'src_img_fam=ubuntu-1604-lts' immutable.json
```
- Создать и запустить ВМ (при создании ВМ спользуется последний из соданных шаблонов reddit-full):
```
config-scripts/create-reddit-vm.sh
```

## 6.3 How to check
С использованием веб-браузера перейти по адресу http://внешний-адрес-ВМ:9292 (Например: https://35.204.252.224:9292 ).
В окне веб браузера отобразится установленное приложение.

# 7. Homework-7: Terraform
## 7.1 What was done
- создан каталог terraform
- в нем созданы конфигурации *.tf для автоматизированного развертывания ВМ с приложением в облаке GCP

В рамках задания со *:
- в конфиг main.tf добавлена возможность добавления ssh-ключей в метаданные проекта
- создан конфиг lb.tf для создания группы ресурсов и баллансировщика нагрузки

## 7.2 How to run the project

- создать файл terraform.tfvars и задать в нем значения переменных tf  (пример заполнения в terraform.tfvars.example);
- выполнить `terraform plan`, убедится в отсутствии ошибок;
- выполнить `terraform apply`
- Done!

## 7.3 How to check

Выполнтиь `terraform output lb_external_ip`

С использованием веб-браузера перейти по адресу указанному в выводе команды.
В окне веб браузера отобразится установленное приложение.

# 8. Homework-8: Terraform-2
## 8.1 What was done
- созданы два описания конфигурации образа для packer (app.json, db.json)
- созданы 2 конфигурации TF для приложения и БД;
- конфигурация и деплой приложения и бд, а также сетевые настройки предаставлены в виде модулей (app, db, vpc);
- созданы два окружения **stage** (доступный с ограниченного числа IP-адресов), и **prod**, доступный всем;
- создана когфигурация storage-bucket.tf для создания бакетов в GCS;

В рамках задания со *:
- состояние TF хранится в созданном бакете **fl64-terraform-backend** и описано в файле backend.tf
- для модулей добавлены возможность провизионинга, которая выполняется в зависимости от значения переменной deply (true\false), значение по умолчанию которой = false

## 8.2 Brief description of the solution

Провизион выполняется в зависимости от значения переменной deploy, условие запуска провизионинга выполнено в виде ресурса null_resource

```
resource "null_resource" "app" {
  count = "${var.deploy ? 1 : 0}"

  triggers {
    cluster_instance_ids = "${join(",", google_compute_instance.app.*.id)}"
  }

  connection {
    host = "${element(google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip, 0)}"
    type        = "ssh"
    user        = "appuser"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {

    content     = "${data.template_file.reddit_app_service.rendered}"
    destination = "/tmp/puma.service"
  }
  provisioner "remote-exec" {
    script = "${path.module}/files/deploy.sh"
  }
}

```

## 8.3 How to run the project

- cd $GITREPO/packer
  - выполнить `packer build -var-file=variables.json app.json`
  - выполнить `packer build -var-file=variables.json db.json`
- cd $GITREPO/terraform/{prod,stage}
  - для stage в **main.tf** необходио задать значние source_ranges = ["внешний-IP"], где внешний ip получаем выполняя `curl ifconfig.co`
  - выполняем `terraform init` для установки нужных модулей и провайдеров, можно просто `terraform get` в случае если провайдеры уже установлены.
  - создать файл terraform.tfvars и задать в нем значения переменных tf  (пример заполнения в terraform.tfvars.example);
  - выполнить `terraform plan`, убедится в отсутсвии ошибок;
  - выполнить `terraform apply`
- Done!

при единовременном запуске `terraform apply`, в stage и prod из-за блокировки tflock запустится тольк один процесс установки

## 8.4 How to check

Выполнтиь `terraform output app_external_ip`

С использованием веб-браузера перейти по адресу указанному в выводе команды.
В окне веб браузера отобразится установленное приложение.

# 9. Homework-9: Ansible-1
## 9.1 What was done
- создан каталог ansible
- созданы файл конфигурации и инвентори файлы (ini, yml, json*) для ansible

В рамках задания со *:
- создан скрипт на bash позволяющий передать json-inventory в ansible

## 9.2 How to run the project

- cd $GITREPO/terraform/stage
  - выполнить `curl ifconfig.me`
  - добавить IP-адрес из вывода предыдущей команды в main.tf (переменна source_ranges = ["xxx.xxx.xxx.xxx"])
  - выполнить `terraform apply`
- cd $GITREPO/ansible/stage
  - выполнить `ansible all -m ping`
  - выполнить `ansible all -m ping -i ./inventory`
  - выполнить `ansible all -m ping -i ./inventory.yml`
  - выполнить `ansible all -m ping -i ./showmejson.sh`
- Done!

## 9.3 How to check

Резульататы выполнения ansible должны показать нечто похожее:

```
[user@default ~/git/fl64_infra/ansible]$ ansible all -m ping
dbserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

```
Ошибки отсутствуют.

