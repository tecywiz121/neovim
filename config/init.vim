"------------------------------------------------------------------------------"
" Neovim Configuration                                                         "
"------------------------------------------------------------------------------"

" Python
"
" Manually set the python interpreters so neovim keeps working with
" virtualenvs.
let g:python_host_prog='/usr/bin/python2'
let g:python3_host_prog='/usr/bin/python3'

" Pathogen
" https://github.com/tpope/vim-pathogen
"
" A vim plugin manager that makes it super easy to install plugins and runtime
" files in their own private directories.
call pathogen#infect()                            " Initialize Pathogen

" Theme
" https://github.com/freeo/vim-kalisi
"
" A theme designed with neovim in mind.
set background=dark                               " Use dark version of theme.
colorscheme kalisi                                " Use kalisi color scheme.

" Tweeks
"
" Small changes that make vim a little easier to use.
syntax on                                         " Enable syntax highlighting.
set wildchar=<Tab> wildmenu wildmode=longest,list " Bash-like completion.
set backspace=indent,eol,start                    " Backspace anything!
set expandtab                                     " Use spaces by default.
set scrolloff=10                                  " Virtual lines around cursor.
set hidden                                        " Switch buffers w/o saving.
set completeopt-=preview                          " Disable completion preview.
set splitright                                    " Open new split to the right.
set nohlsearch                                    " Disable highlight search.
set relativenumber                                " Show relative line numbers.
set inccommand=nosplit                            " Preview substitutions.
set copyindent                                    " Copy previous indent on <CR>.
set nomodeline                                    " No modelines (CVE-2019-12735).
set diffopt+=vertical                             " Open diffs vertically.
set fillchars+=vert:│                             " Nicer vsplit separator.
set number                                        " On current line, show
                                                  " absolute line number.

" Deoplete
" https://github.com/Shougo/deoplete.nvim
"
" Dark powered asynchronous completion framework for neovim/Vim8.
let g:deoplete#enable_at_startup = 1              " Start at startup.
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr><S-tab> pumvisible() ? "\<c-p>" : "\<S-tab>"

" Securemodelines
" https://github.com/step-/securemodelines
"
" A secure alternative to Vim modelines.
let g:secure_modelines_verbose = 1                " Warn if unsupported option set.

" LanguageClient-neovim
" https://github.com/autozimu/LanguageClient-neovim
"
" Client for servers providing language support and features.
let g:LanguageClient_useVirtualText = 'Diagnostics'   " autozimu/LanguageClient-neovim#745
let g:LanguageClient_virtualTextPrefix = ' ╍ '
let g:LanguageClient_serverCommands = {
    \ 'python': ['~/.local/bin/pyls'],
    \ 'rust': ['rls'],
    \ 'cpp': ['clangd'],
    \ 'ruby': ['solargraph', 'stdio'],
    \ 'go': ['~/go/bin/gopls'],
    \ }
nnoremap <leader>jd :call LanguageClient#textDocument_definition()<CR>

" Make error virtual text less... vibrant.
hi Error cterm=italic ctermfg=197 ctermbg=None


" DetectIndent
" https://github.com/roryokane/detectindent
"
" Uses fancy algorithms to try and figure out what style of indentation the
" current buffer uses.
let g:detectindent_preferred_indent = 4           " 4 spaces by default.
autocmd BufReadPost * :DetectIndent               " After reading buffer, detect
                                                  " indentation.

" Filetype
"
" Detects the type of the current file based of the extension and contents,
" and perform actions.
filetype on                                       " Enable the plugin.
filetype indent on                                " Better indentation.
filetype plugin on                                " Load filetype specific
                                                  " plugins.

" Antlr Syntax
au BufRead,BufNewFile *.g4 set filetype=antlr4    " Set filetype for *.g4 files

" Highlight Trailing Whitespace
"
" Track which buffers have been created, and set the highlighting only once.
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1
highlight WhitespaceEOL ctermbg=red ctermfg=white guibg=#592929
autocmd WinEnter *
  \ if !exists('w:created') | call matchadd('WhitespaceEOL', '\s\+$') | endif
call matchadd('WhitespaceEOL', '\s\+$')

" Highlight Past Column 80
"
" Change the background color past column 80 to indicate you've typed too
" much.
highlight ColorColumn ctermbg=239 guibg=#39393b
execute "set colorcolumn=" . join(range(81,335), ',')

" Embedded Terminal
"
" Neovim supports an embedded terminal with :terminal, these tweaks make it a
" little easier to work with.
tnoremap <Esc> <C-\><C-n>                         " Exit terminal with <Esc>

" Add tsplit command to open a new terminal in a split
if !exists(":tsplit")
  command -nargs=? Tsplit vsplit | terminal <args>
  ca tsplit Tsplit
endif

"" Pending https://github.com/neovim/neovim/issues/5310
"" Relative line numbers in terminal (set nonumber to keep margin fixed size)
"autocmd TermOpen * set nonumber relativenumber

" Hardtime
" https://github.com/takac/vim-hardtime
"
" Break bad vim patterns, forces you to use better movement keys.
autocmd VimEnter,BufNewFile,BufReadPost * silent! HardTimeOn
nnoremap <leader>h <Esc>:HardTimeToggle<CR>       " Toggle hardtime with <leader>h.
let g:hardtime_ignore_quickfix = 1                " Disable in quickfix windows.
let g:hardtime_allow_different_key = 1            " Allow different keys in succession.

let g:list_of_normal_keys = ["h", "j", "k", "l",
  \                          "-", "+", "<UP>",
  \                          "<DOWN>", "<LEFT>",
  \                          "<RIGHT>", "<CR>"]   " Which keys to lock.

" Airline
" https://github.com/bling/vim-airline
" https://github.com/powerline/fonts
"
" Sweet looking status line. Requires powerline fonts to be enabled in your
" terminal.
let g:airline_theme='kalisi'                      " Use the kalisi theme!
let g:airline_powerline_fonts=1                   " Enable powerline fonts.
set noshowmode                                    " Don't show mode in command line.
let g:airline#extensions#tabline#enabled=1        " Show the tabline.
let g:airline#extensions#tabline#buffer_nr_show=1 " Show buffer numbers.
let g:airline#extensions#tabline#show_tabs=0      " Don't show tabs in tabline.
let g:airline_section_z = ""                      " Disable line information.

" Don't show VCS hunk summary.
let g:airline_section_b = "%{airline#util#wrap(airline#extensions#branch#get_head(),80)}"

" Truncate the command name to one character.
let g:airline_section_a = "%#__accent_bold#%{strpart(airline#util#wrap(airline#parts#mode(),0),0,1)}%#__restore__#%{airline#util#append(airline#parts#crypt(),0)}%{airline#util#append(airline#parts#paste(),0)}%{airline#util#append(airline#extensions#keymap#status(),0)}%{airline#util#append(airline#parts#spell(),0)}%{airline#util#append(\"\",0)}%{airline#util#append(\"\",0)}%{airline#util#append(airline#parts#iminsert(),0)}"

" Signify
" https://github.com/mhinz/vim-signify
"
" Indicates added, modified and removed lines based on data of an underlying
" version control system.
let g:signify_vcs_list = [ 'git' ]

" ZoomWinTab
" https://github.com/troydm/zoomwintab.vim
"
" Makes <C-w>o toggle zooming in and out
let g:zoomwintab_hidetabbar=0                     " Don't hide tabbar when zoom.

" Neomake
" https://github.com/neomake/neomake
"
" Asynchronously run programs.
highlight NeomakeError ctermfg=196

" Tab Shortcut Keys
"
" Makes opening/closing and switching between tabs easier, stolen from byobu.
nnoremap <F2> :tabnew<CR>
nnoremap <F3> :tabprev<CR>
nnoremap <F4> :tabnext<CR>

" Change highlight of matching braces to make it more obvious
hi MatchParen ctermfg=202 ctermbg=none guifg=#870000 guibg=none

" Keybind to pull up the most recently used hidden terminal buffer.
function! FindTermBuf()
  if exists('b:terminal_job_pid')
    execute('startinsert!')
    return
  endif

  let curbufs = tabpagebuflist()
  let curbufs = filter(curbufs, {i, v -> has_key(getbufinfo(v)[0].variables, 'terminal_job_pid')})
  if !empty(curbufs)
    let bnr = bufwinnr(curbufs[0])
    execute(bnr . 'wincmd w')
    execute('startinsert!')
    return
  endif

  let buffers = getbufinfo({'buflisted': 1})
  let buffers = filter(buffers, {i, v -> v.hidden && has_key(v.variables, 'terminal_job_pid')})
  let buffers = sort(buffers, {i -> i['lastused']})
  if empty(buffers)
    execute('vsplit | terminal')
    execute('startinsert!')
  else
    execute('buffer ' . buffers[0].bufnr)
    execute('startinsert!')
  endif
endfunction

nnoremap <silent> <C-k> :call FindTermBuf()<CR>

" Custom Code Folding
"
" Vim's default fold text isn't super useful, so we replace it with something
" a little better.
set foldlevelstart=99                             " Expand all folds by default.
set foldtext=CustomFoldText()                     " Enable our sweet fold text.
set foldmethod=syntax                             " Fold based on syntax.
function! CustomFoldText()
  " Get the first non-blank line
  let fs = v:foldstart
  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  " Get the last non-blank line
  let fe = v:foldend
  while getline(fe) =~ '^\s*$' | let fe = prevnonblank(fe - 1)
  endwhile

  if fe < v:foldstart
    let eline = getline(v:foldend)
  else
    let eline = substitute(getline(fe), '\t', repeat(' ', &tabstop), 'g')
  endif

  if fs != fe
    let line = line . " ... " . substitute(eline, '^\s*', '', '')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 4 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let lineCount = line("$")
  let expansionString = repeat(" ", w - strwidth(foldSizeStr.line))
  return line . expansionString . foldSizeStr
endfunction
" vim: set et ts=2 sw=2:
