" Set leader key
let mapleader = " "
let maplocalleader = " "

" Disable space in normal mode
nnoremap <space> <Nop>

" Disable PageUp/PageDown
noremap <PageUp> <Nop>
noremap <PageDown> <Nop>
inoremap <PageUp> <Nop>
inoremap <PageDown> <Nop>

" Quick save/quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :x<CR>

" Clear search highlight
nnoremap <leader>h :nohlsearch<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fr <cmd>Telescope oldfiles<CR>

" LSP
nnoremap <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>lr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>lh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>la <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>lf <cmd>lua vim.lsp.buf.format()<CR>
nnoremap <leader>ln <cmd>lua vim.lsp.buf.rename()<CR>
