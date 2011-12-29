#!/bin/zsh

##
#git
##
if which git &> /dev/null ; then
  rm -f ~/.gitconfig
  ln -sf `pwd`/git/gitconfig ~/.gitconfig || (echo '-> git ko!' && break)
  echo '-> git ok!'
else
  echo '-> git not found!'
fi

##
#tmux
##
if which tmux &> /dev/null ; then
  rm -f ~/.tmux
  ln -sf `pwd`/tmux/tmux ~/.tmux || (echo '-> tmux ko!' && break)
  rm -f ~/.tmux.conf
  ln -sf `pwd`/tmux/tmux.conf ~/.tmux.conf || (echo '-> tmux ko!' && break)
  echo '-> tmux ok!'
else
  echo '-> tmux not found!'
fi

##
#vim
##
if which vi &> /dev/null || which vim &> /dev/null ; then
  rm -f ~/.vim
  ln -sf `pwd`/vim/vim ~/.vim || (echo '-> vi(m) ko!' && break)
  rm -f ~/.vimrc
  ln -sf `pwd`/vim/vimrc ~/.vimrc || (echo '-> vi(m) ko!' && break)
  echo '-> vi(m) ok!'
else
  echo '-> vi(m) not found!'
fi

##
#zsh
##
if which zsh &> /dev/null ; then
  echo '(Change your login shell to zsh)' && chsh -s `which zsh` || (echo '-> zsh ko!' && break)
  rm -f ~/.zshrc
  ln -sf `pwd`/zsh/zshrc ~/.zshrc || (echo '-> zsh ko!' && break)
  echo '-> zsh ok!'
else
  echo '-> zsh not found!'
fi
