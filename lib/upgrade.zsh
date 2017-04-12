#!/usr/bin/env zsh

function _Upgrade-core(){

  git --git-dir="$_ZPM_DIR/.git/" --work-tree="$_ZPM_DIR/" checkout "$_ZPM_DIR/" </dev/null >/dev/null 2>/dev/null 
  git --git-dir="$_ZPM_DIR/.git/" --work-tree="$_ZPM_DIR/" pull </dev/null >/dev/null 2>/dev/null 
  pid=$!

  if [[ $COLORS=="true" ]]; then
    echo -en "$fg[green]Updating ZPM  ${fg[yellow]}${spin[0]}"
  else
    echo -en "Updating ZPM  ${spin[0]}"
  fi

  while $( kill -0 $pid 2>/dev/null)
  do
    for i in "${spin[@]}"
    do
      echo -ne "\b$i"
      sleep 0.1
    done
  done
  echo -e "\b✓${reset_color}"

  for i ($_ZPM_Core_Plugins); do
    type _${i}-upgrade | grep -q "shell function" && _${i}-upgrade >/dev/null 2>/dev/null  &!
  done

}

function _Upgrade-plugin(){

  if [[ -d $_ZPM_PLUGIN_DIR/$i ]]; then

    git --git-dir="$_ZPM_PLUGIN_DIR/$i/.git/" --work-tree="$_ZPM_PLUGIN_DIR/$i/" checkout "$_ZPM_PLUGIN_DIR/$i/" </dev/null >/dev/null 2>/dev/null 
    git --git-dir="$_ZPM_PLUGIN_DIR/$i/.git/" --work-tree="$_ZPM_PLUGIN_DIR/$i/" pull</dev/null >/dev/null 2>/dev/null 
    pid=$!

    if [[ $COLORS=="true" ]]; then
      echo -en "${fg[green]}Updating ${fg[cyan]} ${1} ${fg[green]} from ${fg[blue]}GitHub  ${fg[yellow]}${spin[0]}"
    else
      echo -en "Updating ${1} from GitHub  ${spin[0]}"
    fi

    while $( kill -0 $pid 2>/dev/null)
    do
      for i in "${spin[@]}"
      do
        echo -ne "\b$i"
        sleep 0.1
      done
    done
    echo -e "\b✓${reset_color}"
  fi
  type _${i}-upgrade | grep -q "shell function" && _$plugg-upgrade >/dev/null 2>/dev/null  &!

}


function ZPM-Upgrade(){
  _Plugins_Upgrade=()

  if [[ -z $@ ]]; then
    _Plugins_Upgrade+=( "ZPM" $_ZPM_GitHub_Plugins )
  else
    _Plugins_Upgrade+=($@)
  fi

  for i ($_Plugins_Upgrade); do
    if [[ "$i" == "ZPM" ]]; then
      _Upgrade-core
    else
      _Upgrade-plugin $i
    fi
  done
}

function _ZPM-Upgrade(){
  _ZPM_Hooks=( "$_ZPM_GitHub_Plugins" )
  for plugg ($_ZPM_Core_Plugins); do
    if type _$plugg-upgrade | grep "shell function" >/dev/null; then
      _ZPM_Hooks+=($plugg)
    fi
  done
  _arguments "*: :($(echo ZPM; echo $_ZPM_Hooks))"
}

compdef _ZPM-Upgrade ZPM-Upgrade