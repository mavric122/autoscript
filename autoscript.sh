#!/bin/bash

nekoray_status_install=false
yande_browser_status_install=false
obsidian_status_install=false
google_chrome_install=false

# Проверка и установка пакета dialog
if ! command -v dialog &> /dev/null
then
    sudo apt install dialog --yes
fi

# Функция описывающая в конце скрипта удачу/неудачу
report () {
  local prog="$1"
  case $prog in
          "nekoray")

                      if [ "$nekoray_status_install" = true ]
                      then
                        echo "++++++++ Nekoray успешно установлен ++++++++++"
                      else
                        echo "-------- Nekoray ошибка --------"
                      fi
                      ;;
          "yandex")

                    if [ "$yande_browser_status_install" = true ]
                    then
                      echo "++++++++ Yandex browser успешно установлен ++++++++++"
                    else
                      echo "-------- Yandex browser ошибка --------"
                    fi
                    ;;
          "obsidian")

                    if [ "$obsidian_status_install" = true ]
                    then
                      echo "++++++++ Obsidian успешно установлен ++++++++++"
                    else
                      echo "-------- Obsidian ошибка --------"
                    fi
                    ;;
          "google_chrome")
                    if [ google_chrome_install = true ]
                    then
                      echo "++++++++ Google-Chrome успешно установлен ++++++++++"
                    else
                      echo "-------- Google-Chrome ошибка --------"
                    fi
                    ;;
  esac
}

# Блок с программами

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
  sudo add-apt-repository --yes 'deb https://repo.yandex.ru/yandex-browser/deb beta main' || { echo "Ошибка при скачивании Yandex browser" ; return 1 ; }
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60B9CD3A083A7A9A || { echo "Ошибка при добавлении ключа GPG" ; return 1 ; }
  sudo apt update || { echo "Ошибка при добавлении репозитория" ; return 1; }
  sudo apt install yandex-browser-beta -y || { echo "Ошибка при установке Yandex browser" ; return 1 ; }
  yande_browser_status_install=true
  echo "Yandex browser установлен"
}

obsidian_install () {
  echo "Скачиваю Obsidian"
  wget -O Obsidian.deb https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.8/obsidian_1.5.8_amd64.deb || { echo "Ошибка при скачивании Obsidian" ; return 1; }
  sudo dpkg -i Obsidian.deb || { echo "Ошибка при установке Obsidian.deb" ; return 1 ; }
  sudo rm Obsidian.deb || { echo "Ошибка при удалении Obsidian.deb" ; return 1; }
  obsidian_status_install=true
  echo "Obsidian установлен"
}

google_chrome_install () {
  echo "Скачиваю Google-Chrome"
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - || { echo "Ошибка при скачивании пакета Google-Chrome" ; return 1 ; }
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' || { echo "Ошибка при добавлении пакета Google-Chrome" ; return 1 ; }
  sudo apt update
  sudo apt-get install google-chrome-stable || { echo "Ошибка при установке Google-Chrome" ; return 1; } #Ошибка тут.
  google_chrome_install=true
  echo "Google-Chrome установлен"
}



# Отображение диалогового окна выбора
menu() {
    CHOICE=$(dialog --clear --title "Выберите опцию" --menu "Выберите один из вариантов:" 15 40 3 \
            1 "Установить всё" \
            2 "Основной блок (Мультимедия и интернет" \
            3 "Установить Nekoray" \
            4 "Установить Yandex browser" \
            5 "Установить Obsidian" \
            6 "Установить Google-Chrome" \
            2>&1 >/dev/tty)

    # Проверка выбора пользователя и выполнение соответствующих действий
    case $CHOICE in
            1)
                clear
                nekoray_install
                yandex_browser_install
                obsidian_install
                echo "---------------------------------------------------"
                echo "ОТЧЁТ:"
                program="nekoray"
                report "$program"

                program="yandex"
                report "$program"

                program="obsidian"
                report "$program"
                ;;
            2)
                clear
                nekoray_install
                yandex_browser_install
                echo "---------------------------------------------------"
                echo "ОТЧЁТ:"
                program="nekoray"
                report "$program"

                program="yandex"
                report "$program"
                ;;
            3)
                clear
                nekoray_install
                program="nekoray"
                report "$program"
                ;;
            4)
                clear
                yandex_browser_install
                program="yandex"
                report "$program"
                ;;
            5)
                clear
                obsidian_install
                program="obsidian"
                report "$program"
                ;;
            6)
                clear
                google_chrome_install
                program="google_chrome"
                report "$program"
                ;;
    esac
}

menu


