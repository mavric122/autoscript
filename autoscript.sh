#!/bin/bash

nekoray_status_install=false
yande_browser_status_install=false

# Проверка и установка пакета dialog
if ! command -v dialog &> /dev/null
then
    sudo apt install dialog --yes
fi

nekoray_install () {
  echo "Скачиваю nekoray"
  wget -O nekoray.zip https://github.com/MatsuriDayo/nekoray/releases/download/3.26/nekoray-3.26-2023-12-09-linux64.zip || { echo "Ошибка при скачивании nekoray" ; return 1; }
  unzip -q nekoray.zip || { echo "Ошибка при распаковке nekoray" ; return 1; }
  sudo rm -r nekoray.zip || { echo "Ошибка при удалении скаченного архива" ; return 1; }
  wget https://github.com/mavric122/autoscript/raw/main/Пароль.txt || { echo "Ошибка при скачивании пароля"; }
  sudo apt install gnome-terminal --yes || { echo "Системная ошибка 1"; }
  gnome-terminal -- bash -c "openssl enc -d -aes-256-cbc -in Пароль.txt -pbkdf2; read -p 'Нажмите Enter для продолжения...'"
  sudo chmod -R 777 nekoray/ || { echo "Не выданы права nekoray"; }
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

# Отображение диалогового окна выбора
menu() {
    CHOICE=$(dialog --clear --title "Выберите опцию" --menu "Выберите один из вариантов:" 15 40 3 \
            1 "Установить всё" \
            2 "Установить Nekoray" \
            3 "Установить Yandex browser" \
            2>&1 >/dev/tty)

    # Проверка выбора пользователя и выполнение соответствующих действий
    case $CHOICE in
            1)
                clear
                nekoray_install
                yandex_browser_install
                echo "---------------------------------------------------"
                echo "ОТЧЁТ:"
                if [ "$nekoray_status_install" ]
                then
                  echo "++++++++ Nekoray успешно установлен ++++++++++"
                else
                  echo "-------- Nekoray ошибка --------"
                fi

                if [ "$yande_browser_status_install" ]
                then
                  echo "++++++++ Yandex browser успешно установлен ++++++++++"
                else
                  echo "-------- Yandex browser ошибка --------"
                fi

                ;;
            2)
                clear
                nekoray_install
                if [ "$nekoray_status_install" ]
                then
                  echo "++++++++ Nekoray успешно установлен ++++++++++"
                else
                  echo "-------- Nekoray ошибка --------"
                fi
                ;;
            3)
                clear
                yandex_browser_install
                if [ "$yande_browser_status_install" ]
                then
                  echo "++++++++ Yandex browser успешно установлен ++++++++++"
                else
                  echo "-------- Yandex browser ошибка --------"
                fi
                ;;
    esac
}

menu


