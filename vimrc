set t_Co=16
" Load plugins that ship with Vim {{{1
runtime macros/matchit.vim
runtime ftplugin/man.vim

set tags+=tags;/

" Allow for tmux borked ctrl arrow keys
if &term =~? '^screen'
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

" match OverLength /\%81v.\+/
if has('mouse')
    " Don't want the mouse to work in insert mode.
    set mouse=nv
endif
set matchtime=0 "Dont jump around highlighting braces
let g:loaded_matchparen = 1

" Tab-completion in command-line mode
set wildmenu
set wildmode=longest:full
set completeopt=longest,menu,preview

" Appearance {{{2
set ruler
set showcmd
set laststatus=2
set encoding=utf-8
scriptencoding utf-8
set listchars=tab:▸\ ,trail:•
" set list
",eol:¬
set relativenumber
set number
" When the terminal has colors, enable syntax+search highlighting
if &t_Co > 2 || has('gui_running')
    syntax on
    set hlsearch
endif
set winwidth=87
set winminwidth=20
set clipboard^=unnamedplus

" folding
set foldlevelstart=99
set foldmethod=syntax
" set foldcolumn=1
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
    call mkdir(expand(&undodir), 'p')
endif

set nobackup
set noswapfile



" To show all commands that start with leader type :map <leader>
" leader mappings
let g:mapleader = ' '

" location list
nnoremap <leader>l :lopen<CR>

" vim plug
nnoremap <leader>I :source ~/.vimrc<CR>:PlugUpdate<CR>

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
" nmap <leader>h :vs <C-R>=expand("%:r")."."<CR>
" nmap <leader>AT :Etest <C-R>=expand("%:r")<CR><CR>
" nmap <leader>AH :Eheader <C-R>=substitute(expand("%:r"), "UnitTest", "", "g")<CR><CR>
" nmap <leader>AS :Esource <C-R>=expand("%:r")<CR><CR>
" nmap <leader>H :vs <C-R>=expand("%:h")."/CMakeLists.txt"<CR><CR>

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

" mapping to drop into substitute 
nnoremap <leader>s :%s///gc<Left><Left><Left>
nnoremap <leader>S :cdo s///gc<Left><Left><Left>


if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup plugins
        au!
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup end
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
if has('autocmd')
    " commentary adjustment
    autocmd FileType c,h,cpp,hpp,cs,java setlocal commentstring=//\ %s
endif

" easy navigation keybinds
Plug 'tpope/vim-unimpaired'


" Git interface I massively underuse, mostly only use Gblame, GStatus is super
" epic and i know i should use it
Plug 'tpope/vim-fugitive'
nnoremap <leader>g :Gstatus<CR>


" Projectionist plugin to let me jump around code, not really in use yet
Plug 'tpope/vim-projectionist'

Plug 'tpope/vim-speeddating'


" Fuzzy searching ripgrep and ctrlp and fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'git ctags'
let g:fzf_history_dir = '~/.local/share/fzf-history'
" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'jremmen/vim-ripgrep'
Plug 'dbakker/vim-projectroot'
if executable('rg')
    set grepprg=rg\ --vimgrep\ --color=never
    " let g:ctrlp_user_command = 'rg %s --files --hidden --follow --color=never --glob ""'
    " let g:ctrlp_use_caching = 1
    " Ripgrep search word under cursor
endif
set wildignore=*.pdf,*.fo,*.o,*.jpeg,*.jpg,*.png
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/.git/*,*/tmp/*,*.swp,tags
set wildignore+=$HOME/Library/*
set suffixes=.otl
" let g:ctrlp_custom_ignore = {
"             \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"             \ 'file': '\v\.(exe|so|dll)$',
"             \ 'link': 'some_bad_symbolic_links',
"             \ }
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlPMixed'

function! <SID>AutoProjectRootCD()
    try
        if &filetype !=# 'help'
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
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fp :Files<CR>
nnoremap <C-p> :Files<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>f~ :Files ~/<CR>
" nnoremap <leader>t :Tags<CR>
nnoremap <leader>* :execute "Rg! ".expand("<cword>").""<CR>
nnoremap <leader>fA :Rg!<CR>
nnoremap <leader>fa :Rggg<CR>
nnoremap <leader>ft :call fzf#vim#tags(expand('<cword>')." ", {'options': '--exact --select-1 --exit-0'})<CR>
nnoremap <leader>fT :Tags<CR>


" Code Formatting Plugins
Plug 'tell-k/vim-autopep8'
let g:autopep8_max_line_length=79
let g:autopep8_aggressive=2


Plug 'hynek/vim-python-pep8-indent'


Plug 'rhysd/vim-clang-format'
function! Formatonsave()
    let l:formatdiff = 1
    pyf ~/git/clang/tools/clang-format/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()


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
" Plug 'dhruvasagar/vim-zoom'
" nmap <leader>z <Plug>(zoom-toggle)


" VCS agnostic sign gutter plugin
Plug 'mhinz/vim-signify'


" Plug 'tomtom/quickfixsigns_vim'
" let g:quickfixsigns_classes = ['qfl', 'marks', 'breakpoints']
" let g:quickfixsigns_protect_sign_rx = '^neomake_'


" Plug 'vim-scripts/errormarker.vim'


" Plug 'twinside/vim-cuteerrormarker'


" Plug 'jceb/vim-hier'


" Plug 'dannyob/quickfixstatus'


Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_solarized_bg='dark'


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
let g:NERDTreeShowLineNumbers=1
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
Plug 'heavenshell/vim-pydocstring'
nmap <silent> <leader>D <Plug>(pydocstring)

compiler gcc
set makeprg=rscmake

" neovim/vim8 async linter
" Plug 'neomake/neomake'

" let g:neomake_cpp_enabled_makers = ['cppcheck', 'cpplint', 'flawfinder', 'clangtidy', 'clangcheck']

" \   'cpp': ['clangcheck', 'clangtidy', 'cppcheck', 'cpplint', 'flawfinder', 'g++'],


Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'


" \ 'cpp' : ['rscmake', 'cppcheck', 'clangtidy', 'flawfinder'],
Plug 'w0rp/ale'
let g:ale_linters = {
\ 'cpp' : ['rscmake', 'cppcheck', 'clangtidy'],
\ 'rust' : ['rls'],
\}

" \ 'cpp' : ['cppcheck', 'clangtidy', 'clangcheck', 'g++'],
let g:ale_cpp_clangtidy_checks = ['*', '-cppcoreguidelines-pro-bounds-array-to-pointer-decay', '-cppcoreguidelines-pro-type-vararg', '-llvm-include-order', '-cppcoreguidelines-pro-bounds-pointer-arithmetic', '-modernize-make-unique', '-cppcoreguidelines-special-member-functions', '-hicpp-use-equals-default', '-hicpp-use-equals-delete', '-google-readability-namespace-comments', '-llvm-namespace-comment']
let g:ale_echo_msg_format = '%code: %%s %linter%'
" let g:ale_emit_conflict_warnings = 0
let g:ale_fixers = { 
            \ 'sh' : ['shfmt'], 
            \ 'markdown': ['prettier'],
            \ 'rust': ['rustfmt', 'remove_trailing_lines', 'trim_whitespace'],
            \ 'python': ['add_blank_lines_for_python_control_statements', 'autopep8', 'isort', 'yapf'],
            \ }
let g:ale_fix_on_save = 1
let g:ale_proto_protoc_gen_lint_options=''


Plug 'tpope/vim-dispatch'
nnoremap <leader>d :Make<CR>
nnoremap <leader>c :Copen<CR>
nnoremap <leader>q :cfirst<CR>
" nnoremap , @q
" nnoremap <leader>... :<c-u><c-r><c-r>='let @q = '. string(getreg('q'))<cr><c-f><left>

" Plug 'skywind3000/asyncrun.vim'



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
    Plug 'zchee/deoplete-clang'
    Plug 'sebastianmarkow/deoplete-rust'
    Plug 'zchee/deoplete-go', { 'do': 'make'}
    " let g:deoplete#enable_at_startup = 1
    " if !exists('g:deoplete#omni#input_patterns')
    "     let g:deoplete#omni#input_patterns = {}
    " endif
    " " let g:deoplete#disable_auto_complete = 1
    if has('autocmd')
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
    endif
    " deoplete tab-complete
    inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


    Plug 'zhou13/vim-easyescape'
    " easy escape
    let g:easyescape_chars = { 'j': 2 }
    let g:easyescape_timeout = 150
    cnoremap jj <ESC>
endif

function! BuildYCM(info)
    if a:info.status ==# 'installed' || a:info.force
        !./install.py --clang-completer --gocode-completer
    endif
endfunction
" Plug 'Valloric/YouCompleteMe', { 'for': ['c', 'cpp'], 'do': function('BuildYCM') }

Plug 'jceb/vim-orgmode'

Plug 'solarnz/thrift.vim'

" Plug 'pelodelfuego/vim-swoop'

" Plug 'terryma/vim-multiple-cursors'

Plug 'miyakogi/conoline.vim'

Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:ale_sh_shfmt_options = '-i 4'

" Plug 'yggdroot/indentline'


Plug 'flazz/vim-colorschemes'
Plug 'altercation/vim-colors-solarized'


" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'


Plug 'Shougo/neoinclude.vim'
let g:neoinclude#paths = {}
let g:neoinclude#paths.cpp = '~/git/scale-product/daemons/scribed'
if !exists('g:neoinclude#exts')
  let g:neoinclude#exts = {}
endif
let g:neoinclude#exts.cpp = ['', 'h', 'hpp', 'hxx']

Plug 'fatih/vim-go'
call plug#end()


" Fugitive post load
if has('autocmd')
    " Auto-close fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
    " Navigate up one level from fugitive trees and blobs
    autocmd User fugitive
                \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
                \   nnoremap <buffer> .. :edit %:h<CR> |
                \ endif
endif

" Use deoplete.
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_delay = 10
let g:deoplete#auto_completion_start_length = 1
let g:deoplete#skip_chars = ['(', ')']
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#server_timeout = 20
if exists('$CONDA_DEFAULT_ENV')
    let g:deoplete#sources#jedi#python_path = substitute(system('which python'), "\n", '', 'g')
endif
call deoplete#custom#set('jedi', 'rank', 1000)
call deoplete#custom#set('clang', 'rank', 1000)
call deoplete#custom#set('gocode', 'rank', 1000)
call deoplete#custom#set('go', 'rank', 1000)
call deoplete#custom#set('_', 'converters', ['converter_auto_paren'])

let g:deoplete#sources#rust#racer_binary=$HOME.'/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path=$HOME.'/git/rustlang/src/'
let g:deoplete#sources#rust#show_duplicates=1


" Neomake Post Plug
" if has('timer')
"     function! MyOnBattery()
"         return readfile('/sys/class/power_supply/AC/online') == ['0']
"     endfunction
"     if MyOnBattery()
"         call neomake#configure#automake('w')
"     else
"         call neomake#configure#automake('nrw', 1000)
"     endif
" endif
" function! MyOnNeomakeJobFinished() abort
"     let l:context = g:neomake_hook_context
"     botright copen
"     if l:context.jobinfo.exit_code != 0
"         echom printf('The job for maker %s exited non-zero: %s',
"                     \ l:context.jobinfo.maker.name, l:context.jobinfo.exit_code)
"     else
"         echom printf('The job for maker %s finished successfully.',
"                     \ l:context.jobinfo.maker.name)
"     endif
" endfunction
" augroup my_neomake_hooks
"     au!
"     autocmd User NeomakeJobFinished call MyOnNeomakeJobFinished()
" augroup END

command! -bang -nargs=* Ag
            \ call fzf#vim#ag(<q-args>,
            \                 <bang>0 ? fzf#vim#with_preview('up:60%')
            \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
            \                 <bang>0)

command! -bang -nargs=* Rggg
            \ call fzf#vim#rg(<q-args>,
            \                 <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
            \                         : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'),
            \                 <bang>0)

command! -bang -nargs=* Rg
            \ call fzf#vim#rg(<q-args>,
            \                 <bang>0 ? fzf#vim#with_preview('up:60%')
            \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
            \                 <bang>0)

" " Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
" command! -bang -nargs=* Rgg
"   \ call fzf#vim#grep(
"   \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
"   \   <bang>0 ? fzf#vim#with_preview('up:60%')
"   \           : fzf#vim#with_preview('right:50%:hidden', '?'),
"   \   <bang>0)
command! -bang -nargs=* Rgg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=always -v '
            \ . <q-args>, 1,
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
    let l:_s=@/
    let l:l = line('.')
    let l:c = col('.')
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=l:_s
    call cursor(l:l, l:c)
endfunction
nmap _$ :call Preserve("%s/\\s\\+$//e")<CR>

" Escape and paste a register
" <c-x>{char} - paste register into search field, escaping sensitive chars
" http://stackoverflow.com/questions/7400743/
cnoremap <c-x> <c-r>=<SID>PasteEscaped()<cr>
function! s:PasteEscaped()
    echo "\\".getcmdline()."\""
    let l:char = getchar()
    if l:char ==# "\<esc>"
        return ''
    else
        let l:register_content = getreg(nr2char(l:char))
        let l:escaped_register = escape(l:register_content, '\'.getcmdtype())
        return substitute(l:escaped_register, '\n', '\\n', 'g')
    endif
endfunction

function! DeleteHiddenBuffers()
    let l:tpbl=[]
    let l:closed = 0
    call map(range(1, tabpagenr('$')), 'extend(l:tpbl, tabpagebuflist(v:val))')
    for l:buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(l:tpbl, v:val)==-1')
        if getbufvar(l:buf, '&mod') == 0
            silent execute 'bwipeout' l:buf
            let l:closed += 1
        endif
    endfor
    echo 'Closed '.l:closed.' hidden buffers'
endfunction
" nnoremap <leader>d :call DeleteHiddenBuffers()<CR>


" Autocommands
if has('autocmd')
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
    let g:CursorColumnI = 0 "the cursor column position in INSERT
    augroup cursorfix
        au!
        autocmd InsertEnter * let CursorColumnI = col('.')
        autocmd CursorMovedI * let CursorColumnI = col('.')
        autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif
        autocmd BufDelete * call airline#extensions#tabline#buflist#invalidate()
    augroup end
else
    set autoindent		" always set autoindenting on
endif


" indicate highlight groups under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

colorscheme janecolors
