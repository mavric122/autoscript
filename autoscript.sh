#!/bin/bash

nekoray_status_install=false
yande_browser_status_install=false
obsidian_status_install=false
google_chrome_status_install=false
smplayer_status_install=false
syncthing_status_install=false

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
true
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
                    if [ "$google_chrome_status_install" = true ]
                    then
                      echo "++++++++ Google-Chrome успешно установлен ++++++++++"
                    else
                      echo "-------- Google-Chrome ошибка --------"
                    fi
                    ;;
          "smplayer")
                    if [ "$smplayer_status_install" = true ]
                    then
                      echo "++++++++ Smplayer успешно установлен ++++++++++"
                    else
                      echo "-------- Smplayer ошибка --------"
                    fi
                    ;;

          "syncthing")
                    if [ "$syncthing_status_install" = true ]
                    then
                      echo "++++++++ Syncthing успешно установлен ++++++++++"
                    else
                      echo "-------- Syncthing ошибка --------"
                    fi
                    ;;
          *)
                    echo "Ошибка: неизвестный статус для $prog"
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
  sudo apt update || { echo "Ошибка при обновлении репозитория" ; return 1; }
  sudo apt install yandex-browser-beta -y || { echo "Ошибка при установке Yandex browser" ; return 1 ; }
  yande_browser_status_install=trueGoogle-Chrome
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
  sudo bash -c 'echo "wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null" >> /etc/apt/trusted.gpg.d/google.asc'
  sudo bash -c 'echo "# NOTE: On systems with older versions of apt (i.e. versions prior to 1.4), the ASCII-armored" >> /etc/apt/trusted.gpg.d/google.asc'
  sudo bash -c 'echo "# format public key must be converted to binary format before it can be used by apt." >> /etc/apt/trusted.gpg.d/google.asc'
  sudo bash -c 'echo "wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/google.gpg >/dev/null" >> /etc/apt/trusted.gpg.d/google.asc'
  sudo apt update || { echo "Ошибка при обновлении репозитория" ; return 1; }
  sudo apt install google-chrome-stable
  google_chrome_status_install=true
  echo "Google-Chrome установлен"
}

smplayer_install () {
  sudo add-apt-repository ppa:rvm/smplayer --yes || { echo "Ошибка при добавлении репозитория smplayer" ; return 1; }
  sudo apt-get update || { echo "Ошибка при обновлении репозитория" ; return 1; }
  sudo apt-get install smplayer smplayer-themes smplayer-skins --yes || { echo "Ошибка при установке smplayer" ; return 1; }
  smplayer_status_install=true
  echo "Установлен Smplayer"
}

syncthing_install () {
  echo "Начинаю установку Syncthing"
  sudo apt-get update
  sudo apt-get install curl --yes || { echo "Ошибка при установке Curl" ; return 1; }
  sudo mkdir -p /etc/apt/keyrings
  sudo curl -L -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg || { echo "Ошибка при добавлении ключа PGR" ; return 1 ; }
  # Add the "stable" channel to your APT sources:
  echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list || { echo "Ошибка при добавлении репозитория" ; return 1; }
  sudo apt-get update || { echo "Ошибка при обновлении репозитория" ; return 1; }
  sudo apt-get install syncthing || { echo "Ошибка при установке Syncthing" ; return 1; }
  syncthing_status_install=true
}



# Отображение диалогового окна выбора
menu() {
    CHOICE=$(dialog --clear --title "Выберите опцию" --menu "Выберите один из вариантов:" 20 60 3 \
            1 "Установить всё" \
            2 "Основной блок (Мультимедия и интернет" \
            3 "Установить Nekoray" \
            4 "Установить Yandex browser" \
            5 "Установить Obsidian" \
            6 "Установить Google-Chrome" \
            7 "Установить Smplayer" \
            8 "Установить Syncthing" \
            2>&1 >/dev/tty)

    # Проверка выбора пользователя и выполнение соответствующих действий
    case $CHOICE in
            1)
                clear
                nekoray_install
                yandex_browser_install
                obsidian_install
                google_chrome_install
                smplayer_install
                syncthing_install
                echo "---------------------------------------------------"
                echo "ОТЧЁТ:"
                program="nekoray"
                report "$program"

                program="yandex"
                report "$program"

                program="obsidian"
                report "$program"

                program="google_chrome"
                report "$program"

                program="smplayer"
                report "$program"

                program="syncthing"
                report "$program"
                ;;
            2)
                clear
                nekoray_install
                yandex_browser_install
                smplayer_install
                echo "---------------------------------------------------"
                echo "ОТЧЁТ:"
                program="nekoray"
                report "$program"

                program="yandex"
                report "$program"

                program="smplayer"
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
            7)
                clear
                smplayer_install
                program="smplayer"
                report "$program"
                ;;

            8)
                clear
                syncthing_install
                program="syncthing"
                report "$program"
                ;;
    esac
}

menu


