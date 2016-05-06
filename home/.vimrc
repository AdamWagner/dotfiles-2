" Author: Aymeric Beaumet <aymeric@beaumet.me>
" Github: @aymericbeaumet/dotfiles

if !1 | finish | endif " Skip initialization for vim-tiny or vim-small

if exists('&compatible') | set nocompatible | endif " 21st century

syntax enable
filetype plugin indent on

let mapleader = ' '
let b:vim_directory = expand('~/.vim')
let b:bundle_directory = b:vim_directory . '/bundle'
let b:tmp_directory = b:vim_directory . '/tmp'

" Helpers

  " http://stackoverflow.com/a/3879737/1071486
  function! SetupCommandAlias(from, to)
    exec 'cnoreabbrev <expr> '.a:from
    \ . ' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
    \ . '? ("'.a:to.'") : ("'.a:from.'"))'
  endfunction

" Plugins

  call plug#begin(b:bundle_directory)

    " internals

      " junegunn/vim-plug
      autocmd FileType vim-plug call s:on_vimplug_buffer()
      function! s:on_vimplug_buffer()
        nnoremap <silent><buffer> <Esc> <C-w>q
      endfunction

    " theme

      Plug 'tomasr/molokai'

    " filetypes

      Plug 'pangloss/vim-javascript', { 'for': [ 'javascript' ] }
        let javascript_enable_domhtmlcss = 1 " enable HTML/CSS highlighting

      Plug 'elzr/vim-json', { 'for': [ 'json' ] }

    " interface

      Plug 'Lokaltog/vim-easymotion', { 'on': [ '<Plug>(easymotion-s)' ] }
        nmap <silent> S <Plug>(easymotion-s)
        xmap <silent> S <Plug>(easymotion-s)
        omap <silent> S <Plug>(easymotion-s)
        let g:EasyMotion_do_mapping = 1 " disable the default mappings
        let g:EasyMotion_keys = 'LPUFYW;QNTESIROA' " Colemak toprow/homerow
        let g:EasyMotion_off_screen_search = 1 " do not search outside of screen
        let g:EasyMotion_smartcase = 1 " like Vim
        let g:EasyMotion_use_smartsign_us = 1 " ! and 1 are treated as the same
        let g:EasyMotion_use_upper = 1 " recognize both upper and lowercase keys

      Plug 'SirVer/ultisnips'
        let g:UltiSnipsExpandTrigger = '<Tab>'
        let g:UltiSnipsJumpForwardTrigger = '<Tab>'
        let g:UltiSnipsJumpBackwardTrigger = '<S-Tab>'
        let g:UltiSnipsSnippetDirectories = [ 'snippet' ]

      Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer --tern-completer' }
        let g:ycm_collect_identifiers_from_comments_and_strings = 0
        let g:ycm_collect_identifiers_from_tags_files = 0
        let g:ycm_complete_in_comments = 1
        let g:ycm_key_list_previous_completion = [ '<C-p>', '<Up>' ]
        let g:ycm_key_list_select_completion = [ '<C-n>', '<Down>' ]
        let g:ycm_seed_identifiers_with_syntax = 1
        let g:ycm_extra_conf_globlist = [ '~/*' ]

      Plug 'editorconfig/editorconfig-vim'

      Plug 'scrooloose/nerdcommenter'
        " [c]omment / uncomment the current line
        nmap <silent> <Leader>c <Plug>NERDCommenterToggle
        " [c]omment / uncomment the current selection
        xmap <silent> <Leader>c <Plug>NERDCommenterToggle
        let g:NERDCreateDefaultMappings = 0
        let g:NERDCommentWholeLinesInVMode = 1
        let g:NERDMenuMode = 0
        let g:NERDSpaceDelims = 1

      Plug 'tpope/vim-abolish'

      Plug 'tpope/vim-eunuch'

      Plug 'tpope/vim-fugitive'

      Plug 'tpope/vim-repeat'

      Plug 'tpope/vim-surround', { 'on': [ '<Plug>Csurround', '<Plug>Dsurround' ] }
        nmap <silent> cs <Plug>Csurround
        nmap <silent> ds <Plug>Dsurround
        let g:surround_no_mappings = 1 " disable the default mappings
        let g:surround_indent = 1 " reindent with `=` after surrounding

      Plug 'tpope/vim-unimpaired'

      Plug 'vim-airline/vim-airline-themes' | Plug 'vim-airline/vim-airline'
        let g:airline#extensions#disable_rtp_load = 1
        let g:airline_extensions = [ 'branch', 'tabline' ]
        let g:airline_exclude_preview = 1 " remove airline from preview window
        let g:airline_section_z = '%p%% L%l:C%c' " rearrange percentage/col/line section
        let g:airline_theme = 'wombat'
        let g:airline_powerline_fonts = 1
        set noshowmode " hide the duplicate mode in bottom status bar

      Plug 'simeji/winresizer'
        let g:winresizer_start_key = '<C-W><C-W>'

      Plug 'airblade/vim-gitgutter'
        nmap [c <Plug>GitGutterPrevHunk
        nmap ]c <Plug>GitGutterNextHunk
        let g:gitgutter_map_keys = 0
        let g:gitgutter_sign_column_always = 1

      Plug 'scrooloose/nerdtree'
        " [f]ile explorer
        nnoremap <silent> <Leader>f :<C-u>NERDTreeToggle<CR>
        let g:NERDTreeShowHidden = 1
        let g:NERDTreeWinSize = 35
        let g:NERDTreeMinimalUI = 1
        let g:NERDTreeAutoDeleteBuffer = 1
        let g:NERDTreeMouseMode = 3
        let g:NERDTreeRespectWildIgnore = 1 " consider :wildignore
        autocmd FileType nerdtree call s:on_nerdtree_buffer()
        function! s:on_nerdtree_buffer()
          nnoremap <silent><buffer> <Esc> :<C-u>NERDTreeClose<CR>
        endfunction
        autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

      Plug 'majutsushi/tagbar'
        " [t]ags explorer
        nnoremap <silent> <Leader>t :<C-u>TagbarToggle<CR>
        let g:tagbar_width = 35
        let g:tagbar_compact = 1
        let g:tagbar_singleclick = 1
        let g:tagbar_autofocus = 1
        autocmd FileType tagbar call s:on_tagbar_buffer()
        function! s:on_tagbar_buffer()
          nnoremap <silent><buffer> <Esc> :<C-u>TagbarClose<CR>
        endfunction

      Plug 'benekastah/neomake', { 'do': 'go get -u github.com/golang/lint/golint ; npm install --global eslint jsonlint' }
        autocmd FileType javascript,json autocmd BufEnter,BufWritePost * Neomake
        let g:neomake_go_enabled_makers = [ 'go', 'golint', 'govet' ]
        let g:neomake_javascript_enabled_makers = [ 'eslint' ]
        let g:neomake_json_enabled_makers = [ 'jsonlint' ]

      Plug 'Shougo/vimproc.vim', { 'do': 'make' } | Plug 'Shougo/neomru.vim' | Plug 'Shougo/unite.vim'
        " [b]uffers
        nnoremap <silent> <Leader>b :<C-u>Unite -buffer-name=buffer -auto-preview -vertical-preview -no-split buffer<CR>
        " [p]roject files
        nnoremap <silent> <Leader>p :<C-u>Unite -buffer-name=project -auto-preview -vertical-preview -no-split file_rec/git<CR>
        " [r]ecent files
        nnoremap <silent> <Leader>r :<C-u>Unite -buffer-name=recent -auto-preview -vertical-preview -no-split file_mru<CR>
        " [s]hell commands
        nnoremap <silent> <Leader>s :<C-u>Unite -buffer-name=shell -direction=botright menu:shell<CR>
        let g:unite_enable_auto_select = 0
        let g:unite_source_menu_menus = get(g:, 'unite_source_menu_menus', {})
        let g:unite_source_menu_menus.shell = {
        \   'command_candidates': [
        \     [ 'git status', 'Gstatus' ],
        \   ]
        \ }
        autocmd FileType unite call s:on_unite_buffer()
        function! s:on_unite_buffer()
          silent! GitGutterDisable
          imap <silent><buffer> <Esc> i_<Plug>(unite_exit)
        endfunction

  call plug#end()

" Plugins (after loading)

  " 'Shougo/unite.vim'
    call unite#custom#profile('default', 'context', { 'silent': 1, 'start_insert': 1, 'unique': 1, 'wipe': 1 })
    call unite#custom#source('buffer,file_rec/git,file_mru', 'ignore_pattern', 'bower_components/\|coverage/\|docs/\|node_modules/')
    call unite#filters#matcher_default#use([ 'matcher_fuzzy' ])

" Inlined plugins

  " highlight search matches (except while being in insert mode)
  au VimEnter * set hlsearch
  au InsertEnter * setl nohlsearch
  au InsertLeave * setl hlsearch

  " highlight cursor line (except while being in insert mode)
  au VimEnter * set cursorline
  au InsertEnter * setl nocursorline
  au InsertLeave * setl cursorline

  " remember last position in file (line and column)
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line('$') | execute 'normal! g`"' | endif

  " automatically remove trailing whitespace when saving
  au BufWritePre * :%s/\s\+$//e

" Enhanced mappings

  " better `j` and `k`
  nnoremap <silent> j gj
  vnoremap <silent> j gj
  nnoremap <silent> k gk
  vnoremap <silent> k gk

  " copy from the cursor to the end of line using Y (matches D behavior)
  nnoremap <silent> Y y$

  " keep the cursor in place while joining lines (uses the Z register)
  nnoremap <silent> J mZJ`Z

  " disable annoying mappings
  noremap <silent> <F1>   <Nop>
  noremap <silent> <C-w>f <Nop>
  noremap <silent> <Del>  <Nop>
  noremap <silent> q:     <Nop>

  " reselect visual block after indent
  vnoremap <silent> < <gv
  vnoremap <silent> > >gv

  " fix how ^E and ^Y behave in insert mode
  inoremap <silent><expr> <C-e> pumvisible() ? "\<C-y>\<C-e>" : "\<C-e>"
  inoremap <silent><expr> <C-y> pumvisible() ? "\<C-y>\<C-y>" : "\<C-y>"

  " clean screen and reload file
  nnoremap <silent> <C-l>      :<C-u>nohl<CR>:redraw<CR>:checktime<CR><C-l>
  xnoremap <silent> <C-l> <C-c>:<C-u>nohl<CR>:redraw<CR>:checktime<CR><C-l>gv

  " [d]elete the current buffer
  nnoremap <silent> <Leader>d :bdelete!<CR>

  " [w]rite the current buffer
  nnoremap <silent> <Leader>w :write!<CR>

  " [q]uit the current window
  nnoremap <silent> <Leader>q :quit!<CR>

" Settings

  " buffer
  set autoread " watch for file changes by other programs
  set autowrite " automatically save before :next and :make
  set hidden " when a tab is closed, do not delete the buffer

  " cursor
  set nostartofline " leave my cursor alone
  set scrolloff=8 " keep at least 8 lines after the cursor when scrolling
  set sidescrolloff=10 " (same as `scrolloff` about columns during side scrolling)
  set virtualedit=block " allow the cursor to go in to virtual places

  " command
  set history=1000 " increase history size

  " completion
  set completeopt=longest,menuone

  " encoding
  set encoding=utf-8 " ensure proper encoding
  set fileencodings=utf-8 " ensure proper encoding

  " error handling
  set noerrorbells " turn off error bells
  set visualbell t_vb= " turn off error bells

  " help
  call SetupCommandAlias('help', 'vertical help') " open help vertically
  autocmd FileType help call s:on_help_buffer()
  function! s:on_help_buffer()
    nmap <silent><buffer> <Esc> <C-w>q
  endfunction

  " indentation
  set autoindent " auto-indentation
  set backspace=2 " fix backspace (on some OS/terminals)
  set expandtab " replace tabs by spaces
  set shiftwidth=2 " n spaces when using <Tab>
  set smarttab " insert `shiftwidth` spaces instead of tabs
  set softtabstop=2 " n spaces when using <Tab>
  set tabstop=2 " n spaces when using <Tab>

  " interface
  let g:netrw_dirhistmax = 0 " disable netrw
  set fillchars="" " remove split separators
  set formatoptions=croqj " format option stuff (see :help fo-table)
  set laststatus=2 " always display status line
  set shortmess=aoOsI " disable vim welcome message / enable shorter messages
  set showcmd " show (partial) command in the last line of the screen
  set splitbelow " slit below
  set splitright " split right
  set textwidth=80 " 80 characters line

  " mappings
  set timeoutlen=500 " time to wait when a part of a mapped sequence is typed
  set ttimeoutlen=0 " instant insert mode exit using escape

  " modeline
  set modeline " enable modelines for per file configuration
  set modelines=1 " consider the first/last lines

  " mouse
  if has('mouse')
    set mouse=a
    if exists('&ttyscroll') | set ttyscroll=3 | endif
    if exists('&ttymouse') | set ttymouse=xterm2 | endif
  endif

  " performance
  set lazyredraw " only redraw when needed
  if exists('&ttyfast') | set ttyfast | endif " we have a fast terminal

  " search and replace
  set gdefault " default substitute g flag
  set ignorecase " ignore case when searching
  set incsearch " show matches as soon as possible
  set smartcase " smarter search case
  set wildignore= " remove default ignores
  set wildignore+=*.o,*.obj,*.so,*.a,*.dylib,*.pyc " ignore compiled files
  set wildignore+=*.zip,*.gz,*.xz,*.tar,*.rar " ignore compressed files
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/* " ignore SCM files
  set wildignore+=*.png,*.jpg,*.jpeg,*.gif " ignore image files
  set wildignore+=*.pdf,*.dmg " ignore binary files
  set wildignore+=.*.sw*,*~ " ignore editor files
  set wildignore+=.DS_Store " ignore OS files
  set wildmenu " better command line completion menu
  set wildmode=full " ensure better completion

  " spell checking
  if has('spell')
    set spell
  endif

  " system
  set shell=zsh " shell for :sh

  " theme
  colorscheme molokai
  set background=dark
  set colorcolumn=+1 " relative to text-width
  set t_Co=256 " 256 colors

  " undo
  if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
    let &undodir = b:tmp_directory . '/undo//'
  endif

  " vim
  let &viminfo = &viminfo + ',n' . b:tmp_directory . '/info//' " change viminfo file path
  set nobackup " disable backup files
  set nofoldenable " disable folding
  set noswapfile " disable swap files
  set secure " protect the configuration files

" GUI settings

  " MacVim (https://github.com/macvim-dev/macvim)
  " - disable antialiasing with `!defaults write org.vim.MacVim AppleFontSmoothing -int 0`
  if has('gui_macvim')
    " Set the font
    silent! set guifont=Monaco:h13 " fallback
    silent! set guifont=Hack:h13 " preferred
    " Disable superfluous GUI stuff
    set guicursor=
    set guioptions=
    " Use console dialog instead of popup
    set guioptions+=c
    " Disable cursor blinking
    set guicursor+=a:blinkon0
    " Set the cursor as an underscore
    set guicursor+=a:hor8
  endif

  " Neovim.app (https://github.com/neovim/neovim)
  " - disable antialiasing with `!defaults write uk.foon.Neovim AppleFontSmoothing -int 0`
  if exists('neovim_dot_app')
    " Set the font
    silent! call MacSetFont('Monaco', '13') " fallback
    silent! call MacSetFont('Hack', '13') " preferred
  endif
