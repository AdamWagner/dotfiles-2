#!/bin/sh

# Fix path
cd "$(dirname "$0")/.."

##
#config
##
. "$(cd "$(dirname "$0")"; pwd)/config.cfg"

current_path="$(pwd)"
current_user="$(whoami)"

if [ -z "$current_path" ] || [ -z "$current_user" ] ; then
  echo 'Error: need the current path and the current user.'
  exit 1
fi

cmd_exists()
{
  if [ "$#" -eq '0' ] || ! which "$1" &>/dev/null ; then
    return 1
  fi
  return 0
}

do_backup()
{
  if [ -z "$1" ] ; then
    return
  fi
  if [ -f "$1" ] || [ -d "$1" ] ; then
    rm -rf "$1.$BACKUP_EXT"
    mv -f "$1" "$1.$BACKUP_EXT"
  fi
}


##
#warning
##
echo 'This script will install the configuration files for the following programs:'
echo '  - git;'
echo '  - tmux;'
echo '  - vim;'
echo '  - zsh.'
echo
echo -n 'Do you wish to continue [Y/n]? '
while [ "$answer" != 'y' ] && [ "$answer" != 'yes' ] ; do
  if [ "$answer" = 'n' ] || [ "$answer" = 'no' ] ; then
    exit 0
  fi
  read answer
  answer="$(echo $answer | tr '[:upper:]' '[:lower:]')"
  if [ -z "$answer" ] ; then
    break
  fi
done


git submodule update --init
echo '-> Dependencies ok!'


##
#git
##
if cmd_exists git ; then
  git_path="$current_path/_git"

  do_backup "$GIT_CONF_FILE"
  ln -sf "$git_path/conf_file" "$GIT_CONF_FILE"

  echo '-> Git ok!'
fi


##
#tmux
##
if cmd_exists tmux ; then
  tmux_path="$current_path/_tmux"

  do_backup "$TMUX_CONF_FILE"
  ln -sf "$tmux_path/conf_file" "$TMUX_CONF_FILE"
  do_backup "$TMUX_CONF_DIR"
  ln -sf "$tmux_path/data" "$TMUX_CONF_DIR"

  echo '-> Tmux ok!'
fi

##
#vim
##
if cmd_exists vim ; then
  vim_path="$current_path/_vim"

  do_backup "$VIM_CONF_FILE"
  ln -sf "$vim_path/conf_file" "$VIM_CONF_FILE"
  do_backup "$VIM_CONF_DIR"
  ln -sf "$vim_path/data" "$VIM_CONF_DIR"
  mkdir -p "$vim_path/data/autoload"
  rm -rf "$vim_path/data/autoload/pathogen.vim"
  ln -sf "$vim_path/pathogen/autoload/pathogen.vim" "$vim_path/data/autoload/pathogen.vim"

  echo '-> Vim ok!'
fi


##
#zsh
##
if cmd_exists zsh ; then
  zsh_path="$current_path/_tmux"

  if cmd_exists chsh ; then
    echo -n 'Do you want to set your default shell to zsh [y/N]? '
    answer=''
    while [ "$answer" != 'n' ] && [ "$answer" != 'no' ] ; do
      read answer
      answer="$(echo $answer | tr '[:upper:]' '[:lower:]')"
      if [ "$answer" = 'y' ] || [ "$answer" = 'yes' ] ; then
        echo "$current_user, please enter your password to proceed:"
        chsh -s $(which zsh | head -1)
        break
      fi
      if [ -z "$answer" ] ; then
        break
      fi
    done
  fi
  do_backup "$ZSH_CONF_FILE"
  ln -sf "$zsh_path/conf_file" "$ZSH_CONF_FILE"
  do_backup "$ZSH_CONF_DIR"
  ln -sf "$zsh_path/data" "$ZSH_CONF_DIR"

  echo '-> Zsh ok!'
fi


exit 0
