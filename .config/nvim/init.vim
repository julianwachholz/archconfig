" NeoVIM Configuration

" Map the leader key to SPACE
let mapleader="\<SPACE>"
nnoremap <SPACE> <nop>

" Set options {{{
set title               " Set window title to filename
set showcmd             " Show (partial) command in status line
set showmatch           " Show matching brackets
set showmode            " Show current mode
set ruler               " Show line and column numbers of the cursor
set number              " Show line numbers
set formatoptions+=o    " Continue comment marker in new lines
set textwidth=0         " Hard wrap long lines as you type them
set expandtab           " Insert spaces when tab is pressed
set tabstop=2           " Tab is 4 spaces
set shiftwidth=2        " Indentation amounts
set cursorline          " Highlight current cursor line
set autowrite           " Write buffer when switching
set autowriteall        " also when quitting etc
set noerrorbells        " No beeps
set modeline            " Enable modeline
set linespace=0         " line-space minimum
set nojoinspaces        " No two spaces after punctuation in joins
set mouse=a

let base16colorspace=256

set splitbelow
set splitright

" Switch cursor when changing mode
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20

if !&scrolloff
    set scrolloff=3     " Show next 3 lines while scrolling
endif
if !&sidescrolloff
    set sidescrolloff=5 " Show next 5 columns while side-scrolling
endif
set nostartofline       " Do not jump to first char with page commands
" }}}


" Whitespace control {{{
" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$\|\t/

" Remove trailing spaces.
function! TrimWhitespace()
  let l:save = winsaveview()
  %s/\s\+$//e
  call winrestview(l:save)
endfunction
" FIXME: Do not call this on makefile and sv files.
autocmd BufWritePre * call TrimWhitespace()
nnoremap <leader>W :call TrimWhitespace()<CR>
" }}}


" Search {{{
set ignorecase      " Make searching case insensitive
set smartcase       " ... unless query has capital letters
set gdefault        " Use 'g' flag by default with :s/foo/bar/
set magic           " Use magic patterns (extended regex)
" Search and Replace
nmap <Leader>s :%s//g<Left><Left>

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif
" }}}

" Create directories for a new file automatically
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * if expand("<afile>")!~#'^\w\+:/' && !isdirectory(expand("%:h")) | execute "silent! !mkdir -p ".shellescape(expand("%:h"), 1) | redraw | endif
augroup END

autocmd FileType vim,txt setlocal foldmethod=marker


" Mappings {{{
inoremap <C-e> <End>
inoremap <C-a> <Home>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>dd :bdel<CR>
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprev<CR>
" Move lines one up or down
nnoremap <C-S-j> :m .+1<CR>==
nnoremap <C-S-k> :m .-2<CR>==

nmap <Leader>m :make<space>

" Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
    set nornu
    set number
  else
    set rnu
  endif
endfunc

" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>

" Lazy commands
nnoremap ; :
" }}}


let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/usr/bin/python3'


" Plugins {{{
call plug#begin('~/.local/share/nvim/plugged')
    Plug 'Shougo/denite.nvim'                         " Fuzzy matcher
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'airblade/vim-gitgutter'                     " Show modified git lines in gutter
    Plug 'bling/vim-bufferline'                       " Show buffers in statusline
    Plug 'chriskempson/base16-vim'                    " Colorscheme
    Plug 'jreybert/vimagit'                           " Magic Git
    Plug 'scrooloose/nerdcommenter'                   " Commenting
    Plug 'sheerun/vim-polyglot'                       " Proper languages
    Plug 'slashmili/alchemist.vim'                    " Elixir
    Plug 'tmhedberg/SimpylFold'                       " Python folding
    Plug 'tpope/vim-vinegar'                          " Enhance netrw
    Plug 'vim-airline/vim-airline'                    " Light statusline
    Plug 'vim-airline/vim-airline-themes'             " For base16 airline theme
    Plug 'w0rp/ale'                                   " Asynchronous linting engine
call plug#end()
" }}}

" Plugin configuration
colorscheme base16-ocean
let g:airline_theme='base16'

" Magit
nmap <leader>g :Magit<CR>

" Denite {{{
nnoremap <leader><leader> :Denite file_rec<CR>
nnoremap <leader>fl :Denite line<CR>
nnoremap <leader>b :Denite buffer<CR>
nnoremap <leader>ff :Denite grep<CR>

call denite#custom#option('default', {
      \ 'prompt': ''
      \ })
call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy', 'matcher_ignore_globs'])
" Ignore files from results
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '*~', '*.o', '*.exe', '*.bak',
      \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
      \ '.hg/', '.git/', '.bzr/', '.svn/',
      \ 'node_modules/', 'bower_components/', 'tmp/', 'log/', 'vendor/ruby',
      \ '.idea/', 'dist/',
      \ 'deps/', '_build/', 'build/', 'data/',
      \ '.cache/', '.venv/',
      \ 'tags', 'tags-*'])
" use <C-j> <C-k> to navigate results
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
call denite#custom#var('file_rec', 'command',
    \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
    \ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
" }}}

" bufferline
let g:bufferline_echo = 0
let g:bufferline_modified = '*'
let g:bufferline_show_bufnr = 0


" airline {{{
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#enabled = 0
let g:airline_skip_empty_sections = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_alt_sep = ''
let g:airline_symbols.crypt = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.whitespace = 'Ξ'
" }}}


" ALE elixirc linter
" Author: evnu - https://github.com/evnu
function! ElixircHandle(buffer, lines) abort
    " Matches patterns like the following:
    "
    " (CompileError) apps/sim/lib/sim/server.ex:87: undefined function update_in/4
    "
    " TODO include warnings
    let l:pattern = '\v\((CompileError|SyntaxError)\) ([^:]+):([^:]+): (.+)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        let l:type = 'C'
        let l:text = l:match[4]

        call add(l:output, {
        \   'bufnr': a:buffer,
        \   'lnum': l:match[3] + 0,
        \   'col': 0,
        \   'type': l:type,
        \   'text': l:text,
        \})
    endfor

    return l:output
endfunction

function! ElixircCommand(buffer)
    return  'elixirc --warnings-as-errors %s -o /tmp/%t'
endfunction

"call ale#linter#Define('elixir', {
"\   'name': 'elixirc',
"\   'executable': 'elixirc',
"\   'command_callback': 'ElixircCommand',
"\   'callback': 'ElixircHandle',
"\})


" SimpylFold
let g:SimpylFold_docstring_preview = 1
let g:SimpylFold_fold_import = 1

" Netrw
set wildignore=*.pyc,__pycache__,.DS_Store,*.exe,*.sw[po],.git/,node_modules,.idea/,.cache/,.venv/
nnoremap <C-n> :call VexToggle(getcwd())<CR>
nnoremap <C-m> :call VexToggle("")<CR>

fun! VexToggle(dir)
  if exists("t:vex_buf_nr")
    call VexClose()
  else
    call VexOpen(a:dir)
  endif
endf

fun! VexOpen(dir)
  let g:netrw_browse_split=4    " open files in previous window
  let vex_width = 25

  execute "Vexplore " . a:dir
  let t:vex_buf_nr = bufnr("%")
  wincmd H

  call VexSize(vex_width)
endf

fun! VexClose()
  let cur_win_nr = winnr()
  let target_nr = ( cur_win_nr == 1 ? winnr("#") : cur_win_nr )

  1wincmd w
  close
  unlet t:vex_buf_nr

  execute (target_nr - 1) . "wincmd w"
  call NormalizeWidths()
endf

fun! VexSize(vex_width)
  execute "vertical resize" . a:vex_width
  set winfixwidth
  call NormalizeWidths()
endf

fun! NormalizeWidths()
  let eadir_pref = &eadirection
  set eadirection=hor
  set equalalways! equalalways!
  let &eadirection = eadir_pref
endf

augroup NetrwGroup
  autocmd! BufEnter * call NormalizeWidths()
augroup END

" Deoplete {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#max_list = 10
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><tab> pumvisible()? "\<c-n>" : "\<tab>"
" }}}
