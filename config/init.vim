"------------------------------------------------------------------------------"
" Neovim Configuration                                                         "
"------------------------------------------------------------------------------"

" TODO: Look into global statusline (laststatus=3)
" TODO: Find a more active colorscheme than kalisi


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
set wildchar=<Tab> wildmenu wildmode=longest,list " Bash-like completion.
set backspace=indent,eol,start                    " Backspace anything!
set expandtab                                     " Use spaces by default.
set scrolloff=10                                  " Virtual lines around cursor.
set hidden                                        " Switch buffers w/o saving.
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

" nvim-cmp
" https://github.com/hrsh7th/nvim-cmp
"
" A completion engine plugin for neovim written in Lua.
set completeopt=menu,menuone,noselect

imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

lua <<EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    mapping = {
      ['<Tab>'] = cmp.mapping.select_next_item(),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })
EOF

" nvim-lspconfig
" https://github.com/neovim/nvim-lspconfig
"
" A collection of common configurations for Neovim's built-in language server
" client.
lua <<EOF
local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>jd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pylsp', 'rust_analyzer', 'clangd', 'solargraph', 'gopls', 'texlab' }
for _, lsp in pairs(servers) do
  local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

  lspconfig[lsp].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  })
end
EOF

" Make error virtual text less... vibrant.
hi Error cterm=italic ctermfg=197 ctermbg=None


" Filetype
"
" Detects the type of the current file based of the extension and contents,
" and perform actions.
filetype on                                       " Enable the plugin.
filetype indent on                                " Better indentation.
filetype plugin on                                " Load filetype specific
                                                  " plugins.

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

nnoremap <silent> <Leader>k :call FindTermBuf()<CR>

" Custom Code Folding
"
" Vim's default fold text isn't super useful, so we replace it with something
" a little better.
set foldtext=CustomFoldText()                     " Enable our sweet fold text.
set foldmethod=expr                               " Fold based on an expression.
set foldexpr=nvim_treesitter#foldexpr()           " Use tree-sitter for folds.
set foldlevelstart=99                             " Expand all folds by default.

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

" Treesitter
" https://github.com/nvim-treesitter/nvim-treesitter
"
" Provides a concrete syntax tree for source files, and basic functionality
" based on it (such as syntax highlighting.)
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",
  highlight = { enable = true },
  indent = { enable = true }
}
EOF

" vim: set et ts=2 sw=2:
