call pathogen#infect()

syntax on
filetype plugin indent on

set nocompatible

set cursorline
set hidden
set wrap
" set paste
set ruler

" Set encoding
set encoding=utf-8

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:>-,trail:.

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc

" Status bar
set laststatus=2

" CTags
map <Leader>rt :!ctags --extra=+f -R *<CR><CR>

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

function s:setupWrapping()
  set wrap
  set wm=2
  set textwidth=72
endfunction

function s:setupMarkup()
  call s:setupWrapping()
  map <buffer> <Leader>p :Mm <CR>
endfunction

" make and python use real tabs
au FileType make set noexpandtab
au FileType python set noexpandtab

" Thorfile, Rakefile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Thorfile,config.ru,Guardfile} set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

au BufRead,BufNewFile *.txt call s:setupWrapping()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Inserts the path of the currently edited file into a command
" Command mode: Ctrl+P
cmap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Unimpaired configuration
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_warnings=1

" Use modeline overrides
set modeline
set modelines=10

" Default color scheme
set background=light
color solarized

map <F1> <Esc>
imap <F1> <Esc>
imap <C-l> <Space>=><Space>
imap <C-t> <%= t('') %><Esc>F'i
nmap <leader>j :% !json_xs -f json -t json-pretty<CR>
nmap <leader>x :% !xmllint % --format<CR>
nmap <leader>h :% !tidy -q -i -w 0 %<CR>
nmap <leader>l xepldf>
nmap <leader>g :GundoToggle<CR>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

if has("autocmd")
  " Edit schema.rb
  autocmd User BufEnterRails command! Rschema :Redit db/schema.rb
  autocmd User BufEnterRails command! RTschema :RTedit db/schema.rb

  " Edit routes
  autocmd User BufEnterRails command! Rroutes :Redit config/routes.rb
  autocmd User BufEnterRails command! RTroutes :RTedit config/routes.rb

  " Edit database.yml
  autocmd User BufEnterRails command! Rdatabase :Redit config/database.yml
  autocmd User BufEnterRails command! RTdatabase :RTedit config/database.yml

  " Edit factories
  autocmd User BufEnterRails Rnavcommand factory spec/factories -glob=* -suffix=.rb -default=model()
endif

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
if has("autocmd")
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
endif

highlight ExtraWhitespace ctermbg=red guibg=red
if has("autocmd")
  augroup WhitespaceMatch
    " Remove ALL autocommands for the WhitespaceMatch group.
    autocmd!
    autocmd BufWinEnter * let w:whitespace_match_number =
          \ matchadd('ExtraWhitespace', '\s\+$')
    autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
    autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
  augroup END
endif
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction
