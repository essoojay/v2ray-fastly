#!/bin/bash
global_token=""
IP=$(curl -s https://ifconfig.io)

_banner () {
  clear
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
  echo -e "            AUTH CLIENT  |  @kiredev "
  echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}

_auth () {
  read -p "[~] KEY: " key

  res=(`curl --silent http://api.kieredev.shop/client/auth -d "_key=$key" -H "X-Parse-id: 3028377422"`)

  [[ `echo -e $res | grep -E -i -w "invalid_request"` ]] && echo -e "\033[31mHay un erro en la solicitud\033[0m"

  if [[ -z $key ]]; then
    clear
    echo -e "\033[31mPorfavor ingrese una key\033[0m\n"
    _auth
  elif [[ `echo -e $res | grep -E -i -w "invalid_grant"` ]]; then
    clear
    echo -e "\033[31mSu Key es incorrecta. vuelva a intentarlo /o aquiera una nueva \033[0m\n"
    _auth
  elif [[ `echo -e $res | grep -E -i -w "used_key"` ]]; then
    clear
    echo -e "\033[31mEsta key ya fue utilizada, vuelva a intentarlo con otra. \033[0m\n"
    _auth
  fi

  if [[ `echo -e $res | grep -E -i -w "_token"` ]]; then
    clear
    echo -e "\033[32mKey verificada correctamente\033[0m"

    global_token=$(echo "$res" | grep -oP '"_token":"*\K[^"]*')

    if [[ -f "_access.key" ]];then
      rm _access.key
    fi
    echo $global_token >> _access.key
  fi

}

iv2ray () {
  clear && _banner
  echo -e "[!] ingrese su key para activar su cuenta y continuar con la instalacion\n"
  _auth
  [[ ! -f "_access.key" ]] && {
    clear
    echo -e "[*] instalacion truncada"
    echo -e "[!] Este problema es provocado en el servidor del admistrador\n"
    return 0
  }

  source <(curl --silent http://api.kiredev.shop/v2ray/install/{$global_token})
}

__init () {
  #root sistem
  [[ "$(whoami)" != "root" ]] && echo -e "Se nesecita root para correr este script" && return 0
  iv2ray
}

__init
