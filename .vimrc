" http://www.vim.org

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GENERAL                                                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" improved vim, not vi compatible mode, must be first line
set nocompatible
" set shell to zsh
set shell=/usr/local/bin/zsh\ --login
" disable unsecure commands
set secure
" disable error bells
set visualbell
set noerrorbells
" auto read if file is changed from outside
set autoread
" faster redraw
set ttyfast
" lazy redraw
set lazyredraw
" disable backup & swap & undo files
set nobackup
set nowritebackup
set noswapfile
set noundofile
" set utf-8 as standard encoding
set encoding=utf-8 nobomb
set termencoding=utf-8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
scriptencoding utf-8
" set unix as standard file type
set ffs=unix,dos,mac

" save as root with w!!
cmap w!! w !sudo tee > /dev/null %

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" INTERFACE                                                                   "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" enable syntax highlighting
syntax on
" increase syntax accuracy
autocmd BufEnter * :syntax sync fromstart
" enable filetype detection
filetype on
" enable filetype-specific plugins
filetype plugin on
" enable filetype-specific indenting
filetype indent on
" tab autocompletion like in shells
set wildmenu
set wildmode=list:longest,full
" don't show statusline, just ruler
set laststatus=0
" show ruler
set ruler
" show file name, file type, modified & readonly flags, line & column number, percentage through file
set rulerformat=%40(%=%t%y%m%r\ %l,%c%V\ %P%)
" show line numbers
set number
" show current mode
set showmode
" show commands
set showcmd
" set window title
set title
" show matching parenthesis & brackets
"set showmatch (bad performance)
let loaded_matchparen = 1
" include angle brackets in matching
set matchpairs+=<:>
" highlight (underline) the current line
"set cursorline (bad performance)
" no "Hit ENTER to continue"
set shortmess=aOtT
" no extra margin left
set foldcolumn=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" HIGHLIGHTING                                                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use dark background
set background=dark
" use 256 colors
set t_Co=256
" clear current highlighting
highlight clear
" reset syntax
syntax reset

" syntax groups
hi Normal ctermfg=white
hi Comment ctermfg=gray
hi Constant ctermfg=yellow
hi String ctermfg=green
hi Character ctermfg=green
hi Number ctermfg=green
hi Boolean ctermfg=green
hi Float ctermfg=green
hi Identifier ctermfg=white
hi Function ctermfg=blue
hi Statement ctermfg=magenta
hi Conditional ctermfg=magenta
hi Repeat ctermfg=magenta
hi Label ctermfg=magenta
hi Operator ctermfg=magenta
hi Keyword ctermfg=magenta
hi Exception ctermfg=magenta
hi PreProc ctermfg=magenta
hi Include ctermfg=magenta
hi Define ctermfg=magenta
hi Macro ctermfg=magenta
hi PreCondit ctermfg=magenta
hi Type ctermfg=cyan
hi StorageClass ctermfg=magenta
hi Structure ctermfg=yellow
hi Typedef ctermfg=yellow
hi Special ctermfg=red
hi SpecialChar ctermfg=red
hi Tag ctermfg=white
hi Delimiter ctermfg=red
hi SpecialComment ctermfg=cyan
hi Debug ctermfg=gray
hi Underlined cterm=underline
hi Ignore ctermfg=gray
hi Error ctermfg=red
hi Todo ctermfg=blue

" highlighting groups
hi Directory ctermfg=blue
hi LineNr ctermfg=gray

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" EDITOR                                                                      "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use comma as leader
let mapleader        = ","
let g:mapleader      = ","
let maplocalleader   = ","
let g:maplocalleader = ","

if has('clipboard')
  if has('unnamedplus')
    " when possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
  else
    " otherwise use * register for copy-paste
    set clipboard=unnamed
  endif
endif
" use spaces not tabs
set expandtab
set smarttab
" use 2 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2
" indent new lines
set autoindent
set smartindent
set shiftround
" use one space after punctuation, not two
set nojoinspaces
" backspace in insert mode
set backspace=indent,eol,start
" cursor reaches line length + 1 in all modes
set virtualedit=onemore
" don't reset cursor to line start
set nostartofline
" cursor keys in insert mode
set esckeys
" don't add empty newlines at end of files
set binary
set noeol
" don't wrap lines
set nowrap
" always show the number of changed lines
set report=0

" automatically set paste mode when pasting
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ PasteInPasteMode()

function! PasteInPasteMode()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" toggle show whitespace with ,w
set listchars=tab:→·,trail:·,extends:»,precedes:«
nmap <silent> <leader>w :set nolist!<CR>

" toggle word wraping with ,f
nmap <silent> <leader>f :set nowrap!<CR>

" up & down next row not line with word wrap enabled
noremap j gj
noremap k gk
" gi moves to last insert mode, gI moves to last modification
nnoremap gI `.

" select all with ,a
map <Leader>a ggVG

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SEARCH                                                                      "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" global search by default
set gdefault
" case-insensitive search...
set ignorecase
" ...if all lowercase
set smartcase
" highlight search results
set hlsearch
" highlight while typing
set incsearch

" reset search highlights with ,s
nnoremap <leader>s :nohlsearch<CR>