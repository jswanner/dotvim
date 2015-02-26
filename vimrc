call pathogen#infect()
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
" set rtp+=/Users/jacob/Library/Python/2.7/lib/python/site-packages/powerline/bindings/vim

syntax on
filetype plugin indent on

set nocompatible

set cursorline
set hidden
set wrap
set ruler
set noshowmode

" Set encoding
set encoding=utf-8

" Whitespace stuff
set wrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,trail:.

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

" Scrolling
set scrolloff=8
set sidescrolloff=15
set sidescroll=1

" Turn Off Swap Files
set noswapfile
set nobackup
set nowb

" Persistent Undo
silent !mkdir ~/.vimbackups > /dev/null 2>&1
set undodir=~/.vimbackups
set undofile

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

au FileType ruby set kp=ri

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
nmap <leader>l xhepldf>
nmap <leader>r ilet(:^[ea) {^[ldf=A }^[j^
nmap <leader>g :GundoToggle<CR>
nmap <silent> <leader>w :call <SID>StripTrailingWhitespaces()<CR>
vmap <silent> <leader>s :sort<CR>
nnoremap <leader>A :Ack "\b<cword>\b"<CR>

" function! s:RspecCurrentFile()
"   silent !tmux send-keys -t:.+ "rspec %" ^M
"   redraw!
" endfunction
" nmap <leader>t call s:RspecCurrentFile<CR>

" easier tab navigation
map th :tabp<CR>
map tl :tabn<CR>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

if has("autocmd")
  " Edit schema.rb
  autocmd User BufEnterRails command! Rschema :R db/schema.rb
  autocmd User BufEnterRails command! RTschema :RT db/schema.rb

  " Edit routes
  autocmd User BufEnterRails command! Rroutes :R config/routes.rb
  autocmd User BufEnterRails command! RTroutes :RT config/routes.rb

  " Edit database.yml
  autocmd User BufEnterRails command! Rdatabase :R config/database.yml
  autocmd User BufEnterRails command! RTdatabase :RT config/database.yml
endif

let g:rails_projections = {
      \ "config/projections.json": {
      \   "command": "projections"
      \ }}

let g:rails_gem_projections = {
      \ "factory_girl_rails": {
      \   "spec/factories/*.rb": {
      \     "command":   "factory",
      \     "affinity":  "collection",
      \     "alternate": "app/models/%i.rb",
      \     "related":   "db/schema.rb#%s",
      \     "test":      "spec/models/%i_test.rb",
      \     "template":  "FactoryGirl.define do\n  factory :%i do\n  end\nend",
      \     "keywords":  "factory sequence"
      \   }
      \ }}

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
" if has("autocmd")
"   autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" endif

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

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Ack configuration
  let g:ackprg = 'ag --nogroup --nocolor --column'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" See: https://github.com/fatih/vim-go#settings
" let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
" let g:go_fmt_options = "-w"

" Enable vim-mustache-handlebars abbreviations
let g:mustache_abbreviations = 1
