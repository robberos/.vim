" ---- general ----
" pathogen - gen runtime path 'bundle'
execute pathogen#infect()

" golang path
" Clear filetype flags before changing runtimepath to force Vim to reload
" them.
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim

" Turn backup off, since most stuff is in git anyway...
set nobackup
set nowb
set noswapfile

" Sets lines of history
set history=100

" filetype plugins
filetype plugin on
filetype indent on

" Starting with Vim 7, the filetype of empty .tex files defaults to 'plaintex'
" instead of 'tex', which results in vim-latex not being loaded.  The
" following changes the default filetype back to 'tex':
 let g:tex_flavor='latex'

" Grab latest tag in git, if available. To be used by plugins n stuff..
let g:my_latest_tag=system("git describe --abbrev=0 --tags")

" ---- search stuff ----
" ignore case when searching
set ignorecase
set incsearch
set hlsearch
set showmatch
set showcmd
set showfulltag

" ---- UI ----
" syntax & color
set t_Co=256
syntax on
colorscheme symfony

" This statusline requires colors User1, User2 and User3
set statusline=%1*[%n]\ %2*%F\ %1*%y%3*%m%1*%r%=%l:%v\ %p%%\ (%l/%L)
set laststatus=2
"bg color in symfony 233, use brighter?
highlight User1 ctermbg=234
highlight User2 ctermbg=234
highlight User3 ctermbg=234


" display row number
set number
" show current pos
set ruler


" mouse selecting & adding to clipboard
set mouse=a
set mousehide
"set clipboard=autoselect,unnamed,exclude:cons\|linux
set clipboard=unnamed

" Text formatting
set wildignore=*.o,*.pyc
set smartindent
set softtabstop=2
set shiftwidth=2
set expandtab

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Map moving across tabs
noremap <C-Left> :tabprevious<CR>
nnoremap <C-Left> :tabprevious<CR>
inoremap <C-Left> <Esc>:tabprevious<CR>i
noremap <C-Right> :tabnext<CR>
nnoremap <C-Right> :tabnext<CR>
inoremap <C-Right> <Esc>:tabnext<CR>i

" tmux switch pane script
function! CopyWindowInTmux()
  execute ":!~/.vim/tmux_vim_copy.sh %:p ". line(".") " " @/
  execute ":q"
endfunction
noremap <F2> :call CopyWindowInTmux()<CR>
inoremap <F2> <Esc>:call CopyWindowInTmux()<CR>i

" GitGutter by default off, possible to diff to last tag, and mapping...
let g:gitgutter_enabled = 0
let g:my_toggle_mode=0
function! MyGitGutterToggle()
  if g:my_toggle_mode==0
    let g:gitgutter_diff_args = '-w'
    let g:my_toggle_mode=1
  elseif g:my_toggle_mode==1
    let g:gitgutter_diff_args = '-w ' . g:my_latest_tag . '..'
    execute ":GitGutterDisable"
    let g:my_toggle_mode=2
  else
    let g:my_toggle_mode=0
  endif
  execute ":GitGutterToggle"
endfunction
noremap gt :call MyGitGutterToggle()<CR>
noremap gh :GitGutterNextHunk<CR>
noremap gH :GitGutterPrevHunk<CR>

" Show trailing whitespace and spaces before a tab:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$\| \+\ze\t/

" ---- filetype settings ----
au BufNewFile,BufRead *.soap set filetype=xml

autocmd BufEnter *.txt set autoindent tw=78

"autocmd BufEnter *.py set smartindent smarttab
"autocmd BufEnter *.py set smartindent softtabstop=2 shiftwidth=2 expandtab
autocmd BufEnter *.py set cinw=if,while,def,class,else,elif,except,finally,for,try,do,switch

autocmd BufEnter Makefile set shiftwidth=8 | set softtabstop=8
autocmd FileType make set noexpandtab

autocmd BufEnter *.c set cindent
autocmd BufEnter *.h set cindent
autocmd BufEnter *.cpp set cindent
autocmd BufEnter *.hpp set cindent

"autocmd BufEnter *.go set noexpandtab shiftwidth=4 softtabstop=4

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

