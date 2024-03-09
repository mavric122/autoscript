#!/bin/bash

nekoray_status_install=false
yande_browser_status_install=false

nekoray_install () {
  echo "Скачиваю nekoray"
  wget -O nekoray.zip https://github.com/MatsuriDayo/nekoray/releases/download/3.26/nekoray-3.26-2023-12-09-linux64.zip || { echo "Ошибка при скачивании nekoray" ; return 1; }
  unzip -q nekoray.zip || { echo "Ошибка при распаковке nekoray" ; return 1; }
  sudo rm -r nekoray.zip || { echo "Ошибка при удалении скаченного архива" ; return 1; }
  wget https://github.com/mavric122/autoscript/raw/main/Пароль.txt || { echo "Ошибка при скачивании пароля"; }
  sudo apt install gnome-terminal --yes || { echo "Системная ошибка 1"; }
  gnome-terminal -- bash -c "openssl enc -d -aes-256-cbc -in Пароль.txt -pbkdf2; read -p 'Нажмите Enter для продолжения...'"
  sudo chmod -R 777 nekoray/ | { echo "Не выданы права nekoray"; }
  nekoray_status_install=true
  echo "nekoray установлен"
}
yandex_browser_install () {
  echo "Начинаю установку Yandex browser"
  sudo add-apt-repository --yes 'deb https://repo.yandex.ru/yandex-browser/deb beta main' || { echo "Ошибка при скачивании Yandex browser" ; return 1; }
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60B9CD3A083A7A9A || { echo "Ошибка при добавлении ключа GPG" ; return 1; }
  sudo apt update || { echo "Ошибка при добавлении репозитория" ; return 1; }
  sudo apt install yandex-browser-beta -y|| { echo "Ошибка при установке Yandex browser" ; return 1; }
  yande_browser_status_install=true
  echo "Yandex browser установлен"
}

nekoray_install
yandex_browser_install



