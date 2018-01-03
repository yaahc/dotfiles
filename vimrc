set t_Co=16
set nocompatible
" Load plugins that ship with Vim {{{1
runtime macros/matchit.vim
runtime ftplugin/man.vim

set tags+=tags;/

" Allow for tmux borked ctrl arrow keys
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

set backspace=indent,eol,start
set history=50
set incsearch
set ignorecase smartcase
set visualbell t_vb=
set hidden
set nojoinspaces
set nrformats=
set splitright

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
if has('mouse')
    " Don't want the mouse to work in insert mode.
    set mouse=nv
endif
set matchtime=0 "Dont jump around highlighting braces
let loaded_matchparen = 1

" Tab-completion in command-line mode
set wildmenu
set wildmode=longest:full
set completeopt=longest,menu,preview

" Appearance {{{2
set ruler
set showcmd
set laststatus=2
scriptencoding utf-8
set encoding=utf-8
set listchars=tab:▸\ ,trail:•
" set list
",eol:¬
set relativenumber
set number
" When the terminal has colors, enable syntax+search highlighting
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

" folding
set foldlevelstart=99
set foldmethod=syntax
set foldcolumn=1
nnoremap , za

" Indentation {{{2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cinoptions=l1

" Enable persistent undo {{{2
set undofile
set undodir=~/tmp/vim/undo
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif

set nobackup
set noswapfile

" highlight lines in Sy and vimdiff etc.)
highlight DiffAdd           cterm=bold ctermbg=none ctermfg=2
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=1
highlight DiffChange        cterm=bold ctermbg=none ctermfg=3

" fixing search highlighting
hi Search cterm=NONE ctermfg=black ctermbg=yellow


" To show all commands that start with leader type :map <leader>
" leader mappings
let mapleader = " "

" location list
nnoremap <leader>l :lopen<CR>

" vim plug
nnoremap <leader>I :source %<CR>:PlugInstall<CR>

" :terminal easy escape
" if has('nvim')
"     tnoremap jj <C-\><C-n>
"     nnoremap <leader>t :vs term://zsh<CR>
" endif

" tabs & buffers
nnoremap <C-Up> :tabprevious<CR>
nnoremap <C-Down> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
nnoremap <C-Left> :bprevious<CR>
nnoremap <C-Right> :bnext<CR>

" Prompt to open file with same name, different extension
nmap <leader>A :vs <C-R>=expand("%:r")."."<CR>

" Turn off list chars, aka trailing spaces and visible tabs
nmap <silent> <leader>L :set list!<CR>
" Turn off search highlighting
nmap <silent> <leader>n :silent :nohlsearch<CR>

" misc
" keybinds to open last buffer
nmap <leader>v :vs#<cr>

" Fix the & command in normal+visual modes {{{2
nnoremap & :&&<Enter>
xnoremap & :&&<Enter>


" Crude visualmode-only mappings for block level XML tags {{{2
nnoremap viT vitVkoj
nnoremap vaT vatV


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Load Plugins
call plug#begin('~/.vim/plugged')
" Basic common sense config
Plug 'tpope/vim-sensible'


" adds keybinds to manipulate paired surrounding characters like ()
Plug 'tpope/vim-surround'


" lets a lot of plugins repeat with ., the above for example
Plug 'tpope/vim-repeat'


" motion based block commenting plugin
Plug 'tpope/vim-commentary'
if has("autocmd")
    " commentary adjustment
    autocmd FileType c,h,cpp,hpp,cs,java setlocal commentstring=//\ %s
endif

 " easy navigation keybinds
Plug 'tpope/vim-unimpaired'


" Git interface I massively underuse, mostly only use Gblame, GStatus is super
" epic and i know i should use it
Plug 'tpope/vim-fugitive'


" Projectionist plugin to let me jump around code, not really in use yet
Plug 'tpope/vim-projectionist'

Plug 'tpope/vim-speeddating'


" Fuzzy searching ripgrep and ctrlp and fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'dbakker/vim-projectroot'
if executable('rg')
  set grepprg=rg\ --vimgrep
  " let g:ctrlp_user_command = 'rg %s --files --no-ignore --hidden --follow --color=never --glob ""'
  " let g:ctrlp_use_caching = 0
    " Ripgrep search word under cursor
endif
set wildignore=*.pdf,*.fo,*.o,*.jpeg,*.jpg,*.png
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/.git/*,*/tmp/*,*.swp,tags
set wildignore+=$HOME/Library/*
set suffixes=.otl
" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" let g:ctrlp_custom_ignore = {
  " \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  " \ 'file': '\v\.(exe|so|dll)$',
  " \ 'link': 'some_bad_symbolic_links',
  " \ }
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlPMixed'

function! <SID>AutoProjectRootCD()
  try
    if &ft != 'help'
      ProjectRootCD
    endif
  catch
    " Silently ignore invalid buffers
  endtry
endfunction
autocmd BufEnter * call <SID>AutoProjectRootCD()
let g:fzf_layout = { 'down': '~20%' }
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'git ctags'
nnoremap <C-p> :Files<CR>
nnoremap <leader>p :Files<CR>
nnoremap <leader>m :History<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>c :Files ~/
" nnoremap <leader>t :Tags<CR>
nnoremap <leader>* :execute "Ag! ".expand("<cword>").""<CR>
nnoremap <leader>a :Ag!<CR>
nnoremap <leader>t :call fzf#vim#tags(expand('<cword>'), {'options': '--exact --select-1 --exit-0'})<CR>


" Code Formatting Plugins
Plug 'tell-k/vim-autopep8'
let g:autopep8_max_line_length=79
let g:autopep8_aggressive=2


Plug 'hynek/vim-python-pep8-indent'


Plug 'rhysd/vim-clang-format'


" Super useful, lets you navigate between tmux panes and vim panes with the
" same keybinds (ctrl +hjkl) who cares what type of pane it is!!!
Plug 'christoomey/vim-tmux-navigator'


Plug 'tmux-plugins/vim-tmux-focus-events'


Plug 'roxma/vim-tmux-clipboard'


" Tmux zoom emulating plugin TOOD needs work to get it playing nicely with
" NERDTree though in reality its NERDTrees fault, either use vim-session in
" vim-zoom or rework vim-zoom to just spawn a new tab and kill it instead of
" using sessions (though i expect that sessions are the right tool for this
" problem)
Plug 'dhruvasagar/vim-zoom'
nmap <leader>z <Plug>(zoom-toggle)


" VCS agnostic sign gutter plugin
Plug 'mhinz/vim-signify'


Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1


Plug 'octol/vim-cpp-enhanced-highlight'


" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree'
Plug 'xuyuanp/nerdtree-git-plugin'
nnoremap <leader>N :NERDTreeToggle<CR>
" if has("autocmd") autocmd vimenter * NERDTree | wincmd p
"     autocmd StdinReadPre * let s:std_in=1
"     autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
"     autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" endif
" enable line numbers
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber


" Plug 'xolox/vim-easytags'
" Plug 'xolox/vim-misc'
" let g:easytags_async = 1
" let g:easytags_dynamic_files = 1
" let g:easytags_auto_highlight = 0
" let g:easytags_events = ['BufReadPost', 'BufWritePost']
" let g:easytags_resolve_links = 1
" let g:easytags_suppress_ctags_warning = 1


Plug 'majutsushi/tagbar'
nnoremap <silent> <leader>T :TagbarToggle<CR>


" gitv
" highlight diffAdded ctermfg=darkgreen
" highlight diffRemoved ctermfg=darkred
" set lazyredraw
" nmap <leader>gv :Gitv --all<cr>
" nmap <leader>gV :Gitv! --all<cr>
" vmap <leader>gV :Gitv! --all<cr>


" " Gundo.vim {{{2
" nmap <leader>u :GundoToggle<CR>


" " Pydocstring
" nmap <silent> <leader>D <Plug>(pydocstring)


if has('timer')
    " neovim/vim8 async linter
    Plug 'neomake/neomake'
    let g:neomake_cpp_enabled_makers = ['cppcheck', ]
    " Plug 'vim-syntastic/syntastic'
    " let g:syntastic_error_symbol = '✘'
    " let g:syntastic_warning_symbol = "▲"
    " let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_auto_loc_list = 1
    " let g:syntastic_check_on_open = 0
    " let g:syntastic_check_on_wq = 0
    " let g:syntastic_cpp_check_header = 0
    " let g:syntastic_cpp_checkers = ['cppcheck']
    " let g:syntastic_python_checkers = ['python', 'prospector', 'pep8', 'pycodestyle', 'pyflakes', 'pep257', 'pydocstyle', 'pylint']
    " " let g:syntastic_python_prospector_args = "--strictness veryhigh"
    " let g:syntastic_sh_checkers = ['sh', 'shellcheck', 'bashate', 'checkbashisms']
    " let g:syntastic_zsh_checkers = ['zsh', 'sh/shellcheck']
    " " " let g:syntastic_aggregate_errors = 1
    " nmap <leader>c :SyntasticReset<cr>
    " nmap <leader>h :lclose<cr>
endif

if has('python3')
    " Completion Plugin
    if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/deoplete.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif
    Plug 'zchee/deoplete-jedi'
    " Use deoplete.
    let g:deoplete#enable_at_startup = 1
    if !exists('g:deoplete#omni#input_patterns')
      let g:deoplete#omni#input_patterns = {}
    endif
    " let g:deoplete#disable_auto_complete = 1
    if has("autocmd")
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    endif
    " deoplete tab-complete
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


    Plug 'zhou13/vim-easyescape'
    " easy escape
    let g:easyescape_chars = { "j": 2 }
    let g:easyescape_timeout = 150
    cnoremap jj <ESC>
endif

function! BuildYCM(info)
  if a:info.status == 'installed' || a:info.force
    !./install.py --clang-completer --gocode-completer
  endif
endfunction
" Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp'], 'do': function('BuildYCM') }

Plug 'jceb/vim-orgmode'

Plug 'solarnz/thrift.vim'


call plug#end()


" Fugitive post load
if has("autocmd")
    " Auto-close fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
    " Navigate up one level from fugitive trees and blobs
    autocmd User fugitive
                \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
                \   nnoremap <buffer> .. :edit %:h<CR> |
                \ endif
endif

" Neomake Post Plug
if has('timer')
    call neomake#configure#automake('nwr', 1000)
endif

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
let g:fzf_history_dir = '~/.local/share/fzf-history'


" Custom commands
" Strip trailing whitespace
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

" Escape and paste a register
" <c-x>{char} - paste register into search field, escaping sensitive chars
" http://stackoverflow.com/questions/7400743/
cnoremap <c-x> <c-r>=<SID>PasteEscaped()<cr>
function! s:PasteEscaped()
    echo "\\".getcmdline()."\""
    let char = getchar()
    if char == "\<esc>"
        return ''
    else
        let register_content = getreg(nr2char(char))
        let escaped_register = escape(register_content, '\'.getcmdtype())
        return substitute(escaped_register, '\n', '\\n', 'g')
    endif
endfunction

function! DeleteHiddenBuffers()
  let tpbl=[]
  let closed = 0
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    if getbufvar(buf, '&mod') == 0
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction
nnoremap <leader>d :call DeleteHiddenBuffers()<CR>


" Autocommands
if has("autocmd")
    filetype plugin indent on
    au BufNewFile,BufRead *.d set filetype=sh
    augroup vimrcEx
        au!
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif
    augroup END

    " Prevent the cursor from droping back one character after exiting insert mode
    " as possible
    let CursorColumnI = 0 "the cursor column position in INSERT
    autocmd InsertEnter * let CursorColumnI = col('.')
    autocmd CursorMovedI * let CursorColumnI = col('.')
    autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif
    autocmd BufDelete * call airline#extensions#tabline#buflist#invalidate()
else
    set autoindent		" always set autoindenting on
endif
