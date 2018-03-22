- [Homework-4: Intro in GCP](#homework-4-intro-in-gcp)
        - [Description](#description)
        - [Homework](#homework)
        - [Additional homework](#additional-homework)
- [Homework-5: Deploy if the test app](#homework-5-deploy-if-the-test-app)
        - [Description](#description)
        - [What was done](#what-was-done)
        - [Description of startup parameters](#description-of-startup-parameters)
        - [How to Check](#how-to-check)
        - [How do remove](#how-do-remove)

# Homework-4: Intro in GCP

### Description

bastion_IP = 35.204.252.224

someinternalhost_IP = 10.164.0.3

Детальное описание:

- Host: bastion
    - Ext ip: 35.204.252.224
    - Int ip: 10.164.0.2

- Host: someinternalhost
    - Ext ip: none
    - Int ip: 10.164.0.3

### Homework

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

### Additional homework

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

# Homework-5: Deploy if the test app

### Description

testapp_IP = 35.204.89.147

testapp_port = 9292

### What was done
- перенесены скритпы установки и конфиги VPN в каталог VPN
- созданы скрипты установки и настройки приложения (install_rubby.sh, install_mongodb.sh, deploy.sh)
- создан скрипт startup.sh для автоматической установки и настройки приложения при развертывании VM
- Создана VM reddit-app
- Назначен статический-ip

### Description of startup parameters

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


### How to check 

В веб-браузере перейти по адресу http://35.204.89.147:9292, в окне браузера отобразится интерфейс приложения.

### How do remove

Удаление VM
```
gcloud compute instances delete reddit-app
```

Удаление правила МЭ
```
gcloud compute firewall-rules delete default-puma-server

```
