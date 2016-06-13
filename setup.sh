#!/usr/bin/env bash

set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

# Configure the OS
# $ ./setup.sh configure
function __configure {
  case "$(uname -s)" in
    Darwin)
      # Change default shell
      chsh -s "$(which zsh)"
      # Reduce resize time for windows (http://apple.stackexchange.com/a/142734/106194)
      defaults write NSGlobalDomain NSWindowResizeTime .001
      # Disable swipe (http://apple.stackexchange.com/a/80163/106194)
      defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
      # Better looking fonts by disable OS anti-aliasing (http://stackoverflow.com/a/32067365/1071486)
      defaults write org.vim.MacVim AppleFontSmoothing -int 0
      defaults write uk.foon.Neovim AppleFontSmoothing -int 0
      ;;
  esac
}

# Install/Update the dependencies
# $ ./setup.sh install
function __install {
  git submodule update --init
  git submodule foreach git pull origin master
  . ./home/.zshenv # load brew
  brew analytics off
  brew tap homebrew/bundle
  brew update
  brew bundle check || VIM="$HOME/.config/nvim" brew bundle
  "$(brew --prefix fzf)/install" --bin --no-update-rc
}

# Create the symlinks in the $HOME directory
# $ ./setup.sh symlink
function __symlink {
  from_directory="$(pwd)/home"
  find "$from_directory" -type file -o -type link | while read from ; do
    to="$HOME/${from##"$from_directory/"}"
    to_directory="$(dirname "$to")"
    rm -rf "$to"
    mkdir -p "$to_directory"
    ln -shvf "$from" "$to"
  done
}

for command in "${@}" ; do
  if [[ "$(type "__$command")" == *function* ]] ; then
    printf "\e[94m$command...\e[0m"
    __$command
    printf "\e[92mok\e[0m"
  else
    printf "\e[91m-> skipping unknown command '$command'\e[0m" >&2
  fi
done

exit 0
