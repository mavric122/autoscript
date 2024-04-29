#!/bin/bash

# Проверка на sudo
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен быть запущен с правами администратора"
   exit 1
fi

sudo apt update -y
sudo apt upgrade -y

nekoray_status_install=false
yande_browser_status_install=false
obsidian_status_install=false
google_chrome_status_install=false
smplayer_status_install=false
syncthing_status_install=false
virtualbox_status_install=false
vscode_status_install=false
anydesk_status_install=false
telegram_status_install=false
grub_customizer_status_install=false
steam_status_install=false
localtime_status_install=false

# Проверка и установка пакета dialog
if ! command -v dialog &> /dev/null
then
    sudo apt install dialog --yes
fi

# Функция описывающая в конце скрипта удачу/неудачу установки
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
          "virtualbox")
                    if [ "$virtualbox_status_install" = true ]
                    then
                      echo "++++++++ VirtialBox успешно установлен ++++++++++"
                    else
                      echo "-------- VirtialBox ошибка --------"
                    fi
                    ;;
          "vscode")
                    if [ "$vscode_status_install" = true ]
                    then
                      echo "++++++++ VScode успешно установлен ++++++++++"
                    else
                      echo "-------- VScode ошибка --------"
                    fi
                    ;;
          "anydesk")
                    if [ "$anydesk_status_install" = true ]
                    then
                      echo "++++++++ Anydesk успешно установлен ++++++++++"
                    else
                      echo "-------- Anydesk ошибка --------"
                    fi
                    ;;
          "telegram")
                    if [ "$telegram_status_install" = true ]
                    then
                      echo "++++++++ Telegram успешно установлен ++++++++++"
                    else
                      echo "-------- Telegram ошибка --------"
                    fi
                    ;;
          "grub_customizer")
                    if [ "$grub_customizer_status_install" = true ]
                    then
                      echo "++++++++ Grub-customizer успешно установлен ++++++++++"
                    else
                      echo "-------- Grub-customizer ошибка --------"
                    fi
                    ;;
          "steam")
                    if [ "$steam_status_install" = true ]
                    then
                      echo "++++++++ STEAM успешно установлен ++++++++++"
                    else
                      echo "-------- STEAM ошибка --------"
                    fi
                    ;;
          "localtime")
                    if [ "$localtime_status_install" = true ]
                    then
                      echo "++++++++ Синхронизация времени между Windows/Linux успешно установлен ++++++++++"
                    else
                      echo "-------- Синхронизация времени между Windows/Linux ошибка --------"
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
  repository_yandex_1="yandex-browser-beta.list"
  repository_yandex_2="yandex-browser-beta.list.save"
  text_repository="deb [arch=amd64] https://repo.yandex.ru/yandex-browser/deb beta main"
  echo "Начинаю установку Yandex browser"
  echo "$text_repository" | sudo tee /etc/apt/sources.list.d/"$repository_yandex_1" || { echo "Ошибка при добавлении репозитория" ; return 1 ; }
  echo "$text_repository" | sudo tee /etc/apt/sources.list.d/"$repository_yandex_2" || { echo "Ошибка при добавлении репозитория_2" ; return 1 ; }
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 60B9CD3A083A7A9A || { echo "Ошибка при добавлении ключа GPG" ; return 1 ;}
  sudo apt update || { echo "Ошибка при обновлении репозитория" ; return 1 ; }
  sudo apt install yandex-browser-beta -y || { echo "Ошибка при установке Yandex browser" ; return 1 ; }
  yande_browser_status_install=true
  echo "Yandex browser успешно установлен"
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
  # Проверка на наличие curl в системе и его установка при отсутствии
  if ! command -v curl &>/dev/null; then
    sudo apt-get update
    sudo apt-get install curl --yes || { echo "Ошибка при установке Curl"; return 1; }
    echo "Установка curl прошла успешно!"
  fi


  # Создание директории для ключей, если она еще не создана
  sudo mkdir -p /etc/apt/keyrings

  # Путь к файлу с ключом
  KEYRING_PATH="/usr/share/keyrings/syncthing-archive-keyring.gpg"
  # URL ключа
  KEY_URL="https://syncthing.net/release-key.gpg"
  
  if [ ! -f "$KEYRING_PATH" ]; then
    echo "Ключ PGP не найден. Добавляем ключ."
    if ! sudo wget -qO - "$KEY_URL" | gpg --dearmor | sudo tee "$KEYRING_PATH" > /dev/null; then
      echo "Ошибка при добавлении ключа PGP."
      return 1
    fi
    echo "Ключ PGP успешно добавлен."
  else
    echo "Ключ PGP уже добавлен."
  fi

  # Добавление репозитория Syncthing
  echo "deb [signed-by=$KEYRING_PATH] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list > /dev/null || { echo "Ошибка при добавлении репозитория"; return 1; }

  # Обновление репозиториев и установка Syncthing
  sudo apt-get update || { echo "Ошибка при обновлении репозитория"; return 1; }
  sudo apt-get install syncthing --yes || { echo "Ошибка при установке Syncthing"; return 1; }

  echo "Syncthing установлен."
  syncthing_status_install=true
}

virtualbox_install () {
  echo "Начинаю установку VirtualBox"
  wget -O virtualbox.deb https://download.virtualbox.org/virtualbox/7.0.14/virtualbox-7.0_7.0.14-161095~Ubuntu~jammy_amd64.deb || { echo "Ошибка при скачивании VirtualBox!" ; return 1 ; }
  sudo dpkg -i virtualbox.deb || { echo "Ошибка при установке virtualbox"; sudo apt-get -f install -y || { echo "Ошибка при установке зависимостей"; return 1 ; }; }
  echo "Установка VirtualBox прошла успешно"
  virtualbox_status_install=true
}

vscode_install () {
  # Проверка на наличие curl в системе и его установка при отсутствии
  if ! command -v curl &>/dev/null; then
    sudo apt-get update
    sudo apt-get install curl --yes || { echo "Ошибка при установке Curl"; return 1; }
    echo "Установка curl прошла успешно!"
  fi

  key="https://packages.microsoft.com/keys/microsoft.asc"
  repository="deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main"
  echo "Начинаю установку VScode"
  curl -sSL "$key" | gpg --dearmor | sudo tee /usr/share/keyrings/packages.microsoft.gpg >/dev/null || { echo "Ошибка при скачивании ключа GPG" ; return 1 ; }
  echo "$repository" | sudo tee /etc/apt/sources.list.d/vscode.list || { echo "Ошибка при добавлении репозитория" ; return 1; }
  sudo apt-get update
  sudo apt-get install code || { echo "Ошибка при установке VScode" ; return 1 ; }
  echo "Установка VScode прошла успешно"
  vscode_status_install=true
}

anydesk_install () {
  wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add - || { echo "Ошибка при добавлении ключа"; return 1; }
  echo "deb http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk-stable.list || { echo "Ошибка при добавлении репозитория"; return 1; }
  sudo apt-get update
  sudo apt-get install anydesk --yes || { echo "Ошибка при установке Anydesk"; return 1; }
  anydesk_status_install=true
  echo "Anydesk установлен"
}

telegram_install () {
  sudo add-apt-repository ppa:atareao/telegram --yes || { echo "Ошибка при добавлении репозитория" ; return 1 ; }
  sudo apt update || { echo "Ошибка при обновления репозиториев" ; return 1 ; }
  sudo apt install telegram || { echo "Ошибка при установке Telegram" ; return 1 ; }
  telegram_status_install=true
  echo "Telegram установлен"
}

grub_customizer_install () {
  sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y || { echo "Ошибка при добавлении репозитория Grub-customizer" ; return 1 ; }
  sudo apt update || { echo "Ошибка при обновления репозиториев" ; return 1 ; }
  sudo apt install grub-customizer -y || { echo "Ошибка при установке Grub-customizer" ; return 1 ; }
  grub_customizer_status_install=true
  echo "Grub-customizer установлен"
}

steam_install () {
  # Проверка на наличие репозитория
  REPO_URL_PART="multiverse"
  if ! grep -r "^deb .*${REPO_URL_PART}" /etc/apt/sources.list /etc/apt/sources.list.d/ > /dev/null; then
    sudo add-apt-repository multiverse -y || { echo "Ошибка при добавлении репозитория" ; return 1; }
  fi
  sudo apt update || { echo "Ошибка при обновления репозиториев" ; return 1; }
  sudo apt install steam -y || { echo "Ошибка при установке Steam" ; return 1; }
  steam_status_install=true
  echo "Steam установлен"
}

edit_localtime () {
  now_time=$(timedatectl)
  sudo timedatectl set-local-rtc 1 --adjust-system-clock
  sudo timedatectl set-ntp true
  localtime_status_install=true
  echo "Выполнена настройка времени"
  echo "Текущее время $now_time"
}



# Отображение диалогового окна выбора
menu() {
    CHOICE=$(dialog --clear --title "Выберите опцию" --menu "Выберите один из вариантов:" 23 60 3 \
            1 "Установить всё" \
            2 "Основной блок (Мультимедия и интернет" \
            3 "Установить Nekoray" \
            4 "Установить Yandex browser" \
            5 "Установить Obsidian" \
            6 "Установить Google-Chrome" \
            7 "Установить Smplayer" \
            8 "Установить Syncthing" \
            9 "Установить VirtualBox" \
            10 "Установить VScode" \
            11 "Установить Anydesk" \
            12 "Установить Telegram" \
            13 "Установить Grub-customizer" \
            14 "Установить Steam" \
            15 "Устанивить синхронизацию времени Windows/Linux" \
            2>&1 >/dev/tty)

    # Проверка выбора пользователя и выполнение соответствующих действий
    case $CHOICE in
            1)
                clear
                nekoray_install
                #yandex_browser_install
                obsidian_install
                google_chrome_install
                smplayer_install
                syncthing_install
                virtualbox_install
                vscode_install
                anydesk_install
                telegram_install
                grub_customizer_install
                steam_install
                echo "---------------------------------------------------"
                echo "ОТЧЁТ:"
                program="nekoray"
                report "$program"

                #program="yandex"
                #report "$program"

                program="obsidian"
                report "$program"

                program="google_chrome"
                report "$program"

                program="smplayer"
                report "$program"

                program="syncthing"
                report "$program"

                program="virtualbox"
                report "$program"

                program="vscode"
                report "$program"

                program="anydesk"
                report "$program"

                program="telegram"
                report "$program"

                program="grub_customizer"
                report "$program"

                program="steam"
                report "$program"
                ;;
            2)
                clear
                nekoray_install
                yandex_browser_install
                smplayer_install
                google_chrome_install
                anydesk_install
                echo "---------------------------------------------------"
                echo "ОТЧЁТ:"
                program="nekoray"
                report "$program"

                program="yandex"
                report "$program"

                program="smplayer"
                report "$program"

                program="google_chrome"
                report "$program"

                program="anydesk"
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
            9)
                clear
                virtualbox_install
                program="virtualbox"
                report "$program"
                ;;
            10)
                clear
                vscode_install
                program="vscode"
                report "$program"
                ;;
            11)
                clear
                anydesk_install
                program="anydesk"
                report "$program"
                ;;
            12)
                clear
                telegram_install
                program="telegram"
                report "$program"
                ;;
            13)
                clear
                grub_customizer_install
                program="grub_customizer"
                report "$program"
                ;;
            14)
                clear
                steam_install
                program="steam"
                report="$program"
                ;;
            15) 
                clear
                edit_localtime
                program="localtime"
                report="$program"
    esac
}

menu