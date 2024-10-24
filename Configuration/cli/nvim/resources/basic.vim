""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Basic vim settings.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Remove this system directory with C files from the path
set path-=/usr/include

" Run as GUI
if has('gui_running')
    " Remove top menu bar
    set guioptions-=m
    " Remove top toolbar
    set guioptions-=T
    " Remove left scrollbar
    set guioptions-=L
    " Remove right scrollbar
    set guioptions-=r
    " Use console dialogs for simple choices
    set guioptions+=c

    " GUI Font and it's size.
    " When Vim runs in terminal the font is controlled by the terminal.
    "
    " Some good fonts:
    " - Adobe Source Sans Pro
    " - DejaVu Sans Mono
    " - Fantasque Sans Mono
    " - Fira Code
    " - Fira Mono
    " - Hack
    " - Inconsolata
    " - Iosevka
    " - Menlo
    " - Monaco
    " - Terminus
    set guifont=Hack\ 11
endif

" Set window title
set title

" Use TrueColor in terminal
set termguicolors

" Enable mouse support in all modes
set mouse=a

" Plus register is the default register
set clipboard^=unnamedplus

" Set default background.
set background=dark

" Display line numbers
set number
set relativenumber

" Highlight current line number
set cursorline
" Display vertical line/edge at 81 character
set colorcolumn=81

" Search ignoring case unless there is an uppercase character (smartsearch)
set ignorecase smartcase

" Ignore case when looking for words for autocompletion, but follow the case
" of already typed word
set infercase

" Highlight matching brackets
set showmatch
set matchtime=7   " Highlight matching paren (in insert) for that amout of 100ms.

" Indentation
" Only default settings, which are overwritten per filetype in after/ftplugin
"
" Tab characters are never inserted, instead are always expanded to spaces (of
" size tabstop)
set expandtab
" Number of spaces to display for the Tab character
set tabstop=4
" Amount of whitespace to insert on indentation command (e.g. pressing TAB, >>).
" 0 uses tabstop value.
set shiftwidth=0
" Tab size automatically inserted when editing, also how many spaces can a
" backspace deletes at a single press. Should be equal to shiftwidth. Negative
" value uses shiftwidth value.
set softtabstop=-1

" Soft wrapping
"
" Dot not break line in the middle of words
set linebreak
" Prefix each continuation line with this character
set showbreak=…
" Indent reach broken line to the same level as the beginning of the line
set breakindent

" Hard wrapping
"
" Maximum width of the line
set textwidth=80
" Options used when wrapping
set formatoptions+=tron1

" How pressing Tab works in autocomplete mode
set wildmode=list:longest,full

" Sets characters to display in list mode: in place of Tab, EOL, trailing
" whitespace and for lines going out of screen with wrapping off
set listchars=tab:▸\ ,eol:¬,trail:.,extends:>

" Set local leader key.
let maplocalleader='_'

" Information stored between Vim invocations in sessions
set shada='1000,f1,<1000,:1000,@1000,/1000,h,! " In Viminfo

" Set persistent undo
set undofile
