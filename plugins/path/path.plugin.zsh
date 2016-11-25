#!/usr/bin/env zsh

CURRENT_PATH_PREFIX=${CURRENT_PATH_PREFIX:-" "}
CURRENT_PATH_SUFIX=${CURRENT_PATH_SUFIX:-""}

path() {
  echo $PATH | tr ":" "\n" | awk "{ sub(\"/usr\",\"$fg_no_bold[green]/usr$reset_color\"); sub(\"/bin\",\"$fg_no_bold[cyan]/bin$reset_color\"); sub(\"/games\",\"$fg_no_bold[magenta]/games$reset_color\"); sub(\"/opt\",\"$fg_no_bold[cyan]/opt$reset_color\"); sub(\"/sbin\",\"$fg_no_bold[magenta]/sbin$reset_color\"); sub(\"/local\",\"$fg_no_bold[yellow]/local$reset_color\"); print }"
}

p() {
  pa=$(pwd)
  pa=${pa//\//$fg[magenta]\/$fg[cyan]}
  pa=$fg[cyan]$pa
  echo $pa
}

_current_path() {
  if [[ -z "$TMUX" ]]; then

      newHOME=$(echo $HOME | sed 's/\//\\\//g')
      newPWD=$(echo $PWD| sed 's/^'$newHOME'/~/g')

      if [ $(echo -n "$newPWD" | wc -c | tr -d " ") -gt 20 ]; then
          newPWD=$(echo -n "$newPWD" | awk -F '/' '{print $(NF-1) "/" $(NF)}')
        fi

    if [[ $COLORS == "true" ]]; then
      newPWD=${newPWD//\//%{$fg[magenta]%}\/%{$fg[cyan]%}}
      current_path="%{$fg[cyan]%}$CURRENT_PATH_PREFIX$newPWD$CURRENT_PATH_SUFIX%{$reset_color%}"
    else
      current_path="$CURRENT_PATH_PREFIX$newPWD$CURRENT_PATH_SUFIX"
    fi
  fi
}

precmd_functions+=(_current_path)

[[ -d ~/.bin ]] && PATH=$PATH:~/.bin
[[ -d ~/.local/bin ]] && PATH=$PATH:~/.local/bin
