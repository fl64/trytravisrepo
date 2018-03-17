# fl64_infra
fl64 Infra repository

# Homework-4: Знакомство с облачной инфраструктурой GCP

### Описание стенда

bastion_IP = 35.204.252.224
someinternalhost_IP = 10.164.0.3

Детальное описание:

- Host: bastion
	- Ext ip: 35.204.252.224
	- Int ip: 10.164.0.2

- Host: someinternalhost
	- Ext ip: none
	- Int ip: 10.164.0.3

### Самостоятельно задание

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

### Доп. задание

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






