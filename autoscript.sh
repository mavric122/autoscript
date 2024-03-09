#!/bin/bash

nekoray_status_install=false

nekoray_install () {
  home_dir="$(whoami)"
  echo "Начало скрипта"
  mkdir -p /home/$home_dir/program || { echo "Не удалось создать временную папку"; return 1; }
  cd /home/$home_dir/program || { echo "Переход в папку не получился!"; return 1; }
  echo "Скачиваю nekoray"
  wget -O nekoray.zip https://github.com/MatsuriDayo/nekoray/releases/download/3.26/nekoray-3.26-2023-12-09-linux64.zip || { echo "Ошибка при скачивании nekoray" ; return 1; }
  unzip -q nekoray.zip || { echo "Ошибка при распаковке nekoray" ; return 1; }
  rm -r /home/$home_dir/program/nekoray.zip || { echo "Ошибка при удаления скаченного архива" ; return 1; }
  #/home/$home_dir/program/nekoray/nekoray || { echo "Ошибка при запуске nekoray" ; return 1 ;}
  nekoray_status_install=true
  echo "nekoray установлен"
}

nekoray_install
