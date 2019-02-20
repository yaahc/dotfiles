" Load plugins that ship with Vim {{{1
runtime macros/matchit.vim
runtime ftplugin/man.vim

set t_Co=16

set tags+=tags;/

" Allow for tmux borked ctrl arrow keys {{{2
if &term =~? '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif
" }}}2

set backspace=indent,eol,start
set history=50
set incsearch
set ignorecase smartcase
set visualbell t_vb=
set hidden
set nojoinspaces
set nrformats=
set splitright
set switchbuf=useopen

if has('mouse')
    " Don't want the mouse to work in insert mode.
    set mouse=nv
endif

set matchtime=0 "Dont jump around highlighting braces
let g:loaded_matchparen = 1

" Tab-completion in command-line mode {{{2
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
set list
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
set viewoptions=cursor,folds,slash,unix


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

" leader mappings {{{1
" To show all commands that start with leader type :map <leader> " {{{2
" leader mappings
let g:mapleader = ' '

vnoremap . :norm .<CR>

" {{{2 wkm
let g:wkm = {
            \ 'name': '+leader-maps',
            \ '?': ['WhichKey ""', 'help-keybinds'],
            \ '$': 'strip-trailing-whitespace',
            \ '*': 'fzf-search-project-cword',
            \ 'h': 'show-cword-highlight-group',
            \ 'I': 'update-install-all-plugins',
            \ 'b': {'name': '+buffer'},
            \ }

nmap <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

let g:wkm_root = {
            \ 'name': 'JaneVim',
            \ ' ': g:wkm,
            \ '%': 'matching-bracket',
            \ }

" tabs & buffers {{{2
nnoremap <C-Left> :bprevious<CR>
nnoremap <C-Right> :bnext<CR>

" Turn off list chars, aka trailing spaces and visible tabs {{{2
nmap <silent> <leader>L :set list!<CR>
" Turn off search highlighting {{{2
nmap <silent> <leader>n :silent :nohlsearch<CR>

" misc
" keybinds to open last buffer {{{2
nmap <leader>v :vs#<cr>

" mapping to drop into substitute {{{2
let g:wkm.s = {'name': '+substitute'}
nnoremap <leader>ss :%s///gc<Left><Left><Left>
nnoremap <leader>sa :cdo s///gc<Left><Left><Left>

let g:wkm.z = {
            \ 'name': '+fold',
            \ 'o': 'only-current-function',
            \ 'z': 'show-and-center-cursor-line',
            \ }

" tmux mappings {{{2
" Assumes gdb will be open in another tmux session, and that it will be the
" previously selected pane in tmux
let g:wkm.d = {
            \ 'name': '+debugger/tmux-gdb',
            \ 'b': ['TmuxGdbBreak', 'break-at-current-line'],
            \ 'r': ['TmuxGdbRun', 'run'],
            \ 'u': ['TmuxGdbInput', 'input-cmd'],
            \ 'd': ['TmuxGdbInput', 'disable-all-breakpoints'],
            \ }


" indicate highlight groups under cursor {{{2
nnoremap <leader>h :CwordHighlightGroup<CR>

" custom refolder {{{2
nnoremap <leader>zs :call FoldNonSearch()<CR>
nnoremap <leader>zz zvzz
nnoremap <leader>zo zMzO


nnoremap <leader>I :source ~/.vimrc<CR>:PlugUpdate<CR>
" vim plug {{{1
" vim plug autoloader {{{2
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    augroup plugins
        au!
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    augroup END
endif

" Load Plugins
call plug#begin('~/.vim/plugged')
" Basic common sense config
Plug 'tpope/vim-sensible' "{{{2


" adds keybinds to manipulate paired surrounding characters like ()
Plug 'tpope/vim-surround' "{{{2


" lets a lot of plugins repeat with ., the above for example
Plug 'tpope/vim-repeat' "{{{2


" motion based block commenting plugin
Plug 'tpope/vim-commentary' "{{{2
if has('autocmd')
    " commentary adjustment
    augroup commentary
        autocmd!
        autocmd FileType c,h,cpp,hpp,cs,java setlocal commentstring=//\ %s
    augroup END
endif

" easy navigation keybinds
Plug 'tpope/vim-unimpaired' "{{{2


" Git interface I massively underuse, mostly only use Gblame, GStatus is super
" epic and i know i should use it
Plug 'tpope/vim-fugitive' "{{{2
let g:wkm.g = {
            \ 'name' : '+git/version-control' ,
            \ 'b' : ['Gblame'                 , 'fugitive-blame']             ,
            \ 'B' : ['BCommits'               , 'commits-for-current-buffer'] ,
            \ 'C' : ['Gcommit'                , 'fugitive-commit']            ,
            \ 'd' : ['Gdiff'                  , 'fugitive-diff']              ,
            \ 'e' : ['Gedit'                  , 'fugitive-edit']              ,
            \ 'l' : ['Glog'                   , 'fugitive-log']               ,
            \ 'r' : ['Gread'                  , 'fugitive-read']              ,
            \ 's' : ['Gstatus'                , 'fugitive-status']            ,
            \ 'w' : ['Gwrite'                 , 'fugitive-write']             ,
            \ 'p' : ['Git push'               , 'fugitive-push']              ,
            \ 'y' : ['Goyo'                   , 'goyo-mode']                  ,
            \ }


" Projectionist plugin to let me jump around code, not really in use yet
" Plug 'tpope/vim-projectionist'


" Plug 'tpope/vim-speeddating' "{{{2


Plug 'tpope/vim-abolish'


" Fuzzy searching ripgrep and ctrlp and fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "{{{2
Plug 'junegunn/fzf.vim'
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'git ctags'
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_layout = { 'down': '~20%' }
let g:fzf_history_dir = '~/.local/share/fzf-history'

if executable('rg')
    set grepprg=rg\ --vimgrep\ --color=never
endif
set wildignore=*.pdf,*.fo,*.o,*.jpeg,*.jpg,*.png
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=*/.git/*,*/tmp/*,*.swp,tags
set wildignore+=$HOME/Library/*
set suffixes=.otl

let g:wkm.f = {
            \ 'name': '+fzf',
            \ 't': 'fzf-tags-cword',
            \ }

nnoremap <C-p> :Files<CR>
nnoremap <leader>* :execute "Rgg! \\b".expand("<cword>")."\\b"<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fp :Files<CR>
nnoremap <leader>f~ :Files ~/<CR>
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fa :Rgg<CR>
nnoremap <leader>fA :Rgg!<CR>
nnoremap <leader>fd :Rggg<CR>
nnoremap <leader>fD :Rggg!<CR>
nnoremap <leader>fT :Tags<CR>
nnoremap <leader>ft :call fzf#vim#tags(expand('<cword>')." ", {'options': '--exact --select-1 --exit-0'})<CR>
nnoremap <leader>fs :Snippets<CR>


Plug 'dbakker/vim-projectroot' "{{{2


Plug 'junegunn/vader.vim' "{{{2


" Code Formatting Plugins
Plug 'tell-k/vim-autopep8' "{{{2
let g:autopep8_max_line_length=79
let g:autopep8_aggressive=2


Plug 'hynek/vim-python-pep8-indent'


" " Pydocstring
Plug 'heavenshell/vim-pydocstring'
let g:wkm.p = {
            \ 'name': '+python',
            \ 'd' : ['<Plug>(pydocstring)', 'auto-document-current-fn'],
            \ }


" Plug 'rhysd/vim-clang-format' "{{{2

" Super useful, lets you navigate between tmux panes and vim panes with the
" same keybinds (ctrl +hjkl) who cares what type of pane it is!!!
Plug 'christoomey/vim-tmux-navigator' "{{{2


Plug 'tmux-plugins/vim-tmux-focus-events'


Plug 'roxma/vim-tmux-clipboard'


" VCS agnostic sign gutter plugin
Plug 'mhinz/vim-signify' "{{{2


Plug 'bling/vim-airline' "{{{2
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_solarized_bg='dark'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#extensions#gutentags#enabled = 1


Plug 'octol/vim-cpp-enhanced-highlight' "{{{2


" NERD tree will be loaded on the first invocation of NERDTreeToggle command
" Plug 'scrooloose/nerdtree' "{{{2
Plug 'xuyuanp/nerdtree-git-plugin'
" enable line numbers
let g:NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
augroup nerdtree
    autocmd!
    autocmd FileType nerdtree setlocal relativenumber
augroup END


Plug 'majutsushi/tagbar' "{{{2


Plug 'rust-lang/rust.vim' "{{{2
Plug 'mattn/webapi-vim'
let g:rustfmt_autosave = 1

let wkm['r'] = {
            \ 'name': '+rust',
            \ 'f': ['!cargo fix', 'fix'],
            \ }


Plug 'cespare/vim-toml'


if has('nvim')
    " neovim language client {{{2
    Plug 'autozimu/LanguageClient-neovim', {
                \ 'branch': 'next',
                \ 'do': 'bash install.sh',
                \ }
    let g:LanguageClient_loggingLevel = 'DEBUG'

    let g:LanguageClient_serverCommands = {
                \ 'rust': ['rls'],
                \ }
    " \ 'cpp': ['~/git/cquery/build/release/bin/cquery', '--log-file=/tmp/cq.log'],

    let g:LanguageClient_loadSettings = 1
    let g:LanguageClient_settingsPath = '/home/jlusby/.dotfiles/nvim/settings.json'

    let g:wkm['l'] = {
                \ 'name' : '+lsp',
                \ 'a' : ['LanguageClient#textDocument_codeAction()',            'code-action'],
                \ 'c' : ['LanguageClient_contextMenu()',                        'context-menu'],
                \ 'f' : ['LanguageClient#textDocument_formatting()',            'formatting'],
                \ 'd' : ['ALEHover',                                            'hover-doc'],
                \ 'h' : {
                \     'name': '+highlight',
                \ 'h' : ['LanguageClient#textDocument_documentHighlight()', 'highlight-cword'],
                \ 'c' : ['LanguageClient#clearDocumentHighlight()',         'clear-highlight'],
                \ },
                \ 'R' : ['LanguageClient#textDocument_references()',            'references'],
                \ 'r' : ['LanguageClient#textDocument_rename()',                'rename'],
                \ 's' : ['LanguageClient#textDocument_documentSymbol()',        'document-symbol'],
                \ 'S' : ['LanguageClient#workspace_symbol()',                   'workspace-symbol'],
                \ 'g' : {
                \ 'name': '+goto',
                \ 'd' : ['LanguageClient#textDocument_definition()',          'definition'],
                \ 'i' : ['LanguageClient#textDocument_implementation()',      'implementation'],
                \ },
                \ }

    " \ 't' : ['LanguageClient#textDocument_typeDefinition()' , 'type-definition']  ,

    " set completefunc=LanguageClient#complete

    augroup LangCliVimrcAuCmds
        autocmd!
        autocmd InsertLeave * if pumvisible() == 0 | pclose | endif
    augroup END


    Plug 'ludovicchabant/vim-gutentags'

    Plug 'ncm2/ncm2'
    Plug 'roxma/nvim-yarp'

    " Use <TAB> to select the popup menu:
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    imap <silent> <expr> <CR> pumvisible() ? ncm2_ultisnips#expand_or("\<CR>", 'n') : "\<CR>"

    " CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
    inoremap <c-c> <ESC>

    " suppress the annoying 'match x of y', 'The only match' and 'Pattern not
    " found' messages
    set shortmess+=c

    set completeopt=noinsert,menuone,noselect

    " enable ncm2 for all buffers
    augroup ncmEnableCompletion
        autocmd!
        autocmd BufEnter * call ncm2#enable_for_buffer()
    augroup END

    " NOTE: you need to install completion sources to get completions. Check
    " our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki
    Plug 'ncm2/ncm2-bufword'
    Plug 'ncm2/ncm2-tmux'
    Plug 'ncm2/ncm2-path'
    let g:ncm2_path#bufpath_source = {'priority': 4,}
    let g:ncm2_path#cwdpath_source = {'priority': 4,}
    let g:ncm2_path#rootpath_source = {'priority': 4,}
    Plug 'ncm2/ncm2-ultisnips'
    let g:ncm2_ultisnips#source = {'priority': 10}
    Plug 'ncm2/ncm2-tagprefix'
    let g:ncm2_tagprefix#source = {'priority': 3,}
    Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
    Plug 'ncm2/ncm2-markdown-subscope'
endif




Plug 'w0rp/ale' "{{{2
let g:ale_linters = {
            \ 'rust':     ['rls'],
            \ 'cpp':      ['rscmake', 'cppcheck',     'clangtidy', 'gcovcheck'],
            \ 'go':       ['gobuild', 'gofmt',        'golint',    'gometalinter', 'gosimple',    'gotype',   'govet'],
            \ 'markdown': ['alex',    'markdownlint', 'mdl',       'redpen',       'remark-lint', 'textlint', 'vale', 'write-good'],
            \ }

let g:ale_echo_msg_format = '%code: %%s %linter%'
let g:ale_cpp_gcc_options = '-std=c++14 -Wall -IGL'
let g:ale_cpp_clangtidy_checks = []
let g:ale_fixers = {
            \ 'sh':       ['shfmt'],
            \ 'markdown': ['prettier'],
            \ 'python':   ['add_blank_lines_for_python_control_statements', 'black'],
            \ 'haskell':  ['brittany']
            \ }
let g:ale_fix_on_save = 1
let g:ale_proto_protoc_gen_lint_options=''
let g:ale_sh_shfmt_options = '-i 4'
let g:ale_sign_info = 'X'

autocmd FileType rust call s:DisableRustAutoLinting()

Plug 'tpope/vim-dispatch' "{{{2

let g:wkm.a = {
            \ 'name': '+async',
            \ 'c': 'open-dispatch-errors',
            \ 'C': 'run-unit-and-get-coverage',
            \ }

nnoremap <leader>ac :Copen<CR>
nnoremap <leader>aq :cfirst<CR>
nnoremap <leader>aC :Dispatch covrun %:p<CR>



Plug 'sirver/ultisnips' "{{{2
Plug 'honza/vim-snippets'
let g:UltiSnipsExpandTrigger='<NL>'
let g:UltiSnipsListSnippets = '<C-u>'
let g:UltiSnipsJumpForwardTrigger='<CR>'
let g:UltiSnipsJumpBackwardTrigger='<C-k>'
let g:UltiSnipsEditSplit='vertical'
" let g:UltiSnipsRemoveSelectModeMappings = 0


Plug 'solarnz/thrift.vim' "{{{2


Plug 'flazz/vim-colorschemes' "{{{2
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'


Plug 'Shougo/neoinclude.vim' "{{{2
let g:neoinclude#paths = {}
let g:neoinclude#paths.cpp = '~/git/scale-product/daemons/scribed'
if !exists('g:neoinclude#exts')
    let g:neoinclude#exts = {}
endif
let g:neoinclude#exts.cpp = ['', 'h', 'hpp', 'hxx']

" Plug 'fatih/vim-go' "{{{2


" Plug 'google/vim-maktaba'
" Plug 'google/vim-coverage'


" Javascript {{{2
Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'
Plug 'gavocanov/vim-js-indent'
Plug 'mxw/vim-jsx'
Plug 'othree/javascript-libraries-syntax.vim'


Plug 'git+ssh://gerrit.lab.local:29418/scbuild', { 'do': './install.sh' } " {{{2


Plug 'suan/vim-instant-markdown', { 'on': 'InstantMarkdownPreview' } " {{{2
let g:instant_markdown_autostart = 0


Plug 'neovimhaskell/haskell-vim' " {{{2


Plug 'liuchengxu/vim-which-key' " {{{2


Plug 'junegunn/vim-easy-align' " {{{2
let  g:wkm['e'] =['vert help easy-align', '+EasyAlign(ga)']
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
vmap <Enter> <Plug>(EasyAlign)


let g:wkm['T'] = {
            \ 'name': '+toggle',
            \ 'i':    ['IndentGuidesToggle', 'indent-guide'],
            \ 'p':    ['setlocal paste!',    'paste-mode'],
            \ 't':    ['TagbarToggle',       'tagbar'],
            \ 'n':    ['NERDTreeToggle',     'NERDTree'],
            \ 'm':    ['InstantMarkdownPreview', 'markdown-preview'],
            \ }


" Plug 'vim-scripts/restore_view.vim'


" Plug 'zxqfl/tabnine-vim'


Plug 'stephpy/vim-yaml'


Plug 'janko-m/vim-test'
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tg :TestVisit<CR>

call plug#end() " insert above here {{{2


" Post plug configuration {{{2
" whichkey {{{3
call which_key#register('<Space>', 'g:wkm')
call which_key#register('', 'g:wkm_root')
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
set timeoutlen=500
let g:which_key_flatten = 1

" Fugitive post load {{{3
if has('autocmd')
    " Auto-close fugitive buffers
    augroup fugitive
        autocmd!
        autocmd BufReadPost fugitive://* set bufhidden=delete
        " Navigate up one level from fugitive trees and blobs
        autocmd User fugitive
                    \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
                    \   nnoremap <buffer> .. :edit %:h<CR> |
                    \ endif
    augroup END
endif

" fzf {{{3
command! -bang -nargs=* Rgg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=never '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview('up:60%')
            \           : fzf#vim#with_preview('right:50%', '?'),
            \   <bang>0)

command! -bang -nargs=* Rggg
            \ call fzf#vim#grep(
            \   'rg --column --line-number --no-heading --color=never '.shellescape(<q-args>), 1,
            \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
            \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%', '?'),
            \   <bang>0)


" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
            \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" Custom commands {{{1
" Strip trailing whitespace {{{2
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

function! JumpToFile(fileline)
    let filename=split(a:fileline,":")[0]
    let true_filename=system('rg --files -g ' . filename)
    let linenumber=split(a:fileline,":")[1]
    execute "edit +" . linenumber . " " . true_filename
endfunction
nnoremap <leader>J :call JumpToFile(@")<CR>
" DRSD.cpp:120


" Escape and paste a register {{{2
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

function! DeleteHiddenBuffers() " {{{2
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
nnoremap <leader>bD :call DeleteHiddenBuffers()<CR>


function! SetupEnvironment() " {{{2
    let l:path = expand('%:p')
    if l:path =~# $SC_GIT_ROOT
        let b:dispatch = 'covrun %:p'
        compiler rscmake
    elseif l:path =~# $HOME.'/git/notjobless'
        let b:dispatch = './make.sh'
    elseif !empty(glob('./CMakeLists.txt')) && !empty(glob('./build'))
        let b:dispatch = 'make -C build/'
    endif
endfunction


function! Formatonsave() " {{{2
    let l:formatdiff = 1
    " git clone https://github.com/llvm-mirror/clang
    pyf ~/git/clang/tools/clang-format/clang-format.py
endfunction


function! s:exercism_tests() " {{{2
    if expand('%:e') ==# 'vim'
        let testfile = printf('%s/%s.vader', expand('%:p:h'),
                    \ tr(expand('%:p:h:t'), '-', '_'))
        if !filereadable(testfile)
            echoerr 'File does not exist: '. testfile
            return
        endif
        source %
        execute 'Vader' testfile
    else
        let sourcefile = printf('%s/%s.vim', expand('%:p:h'),
                    \ tr(expand('%:p:h:t'), '-', '_'))
        if !filereadable(sourcefile)
            echoerr 'File does not exist: '. sourcefile
            return
        endif
        execute 'source' sourcefile
        Vader
    endif
endfunction


function! <SID>AutoProjectRootCD() " {{{2
    try
        if &filetype !=# 'help'
            ProjectRootCD
        endif
    catch
        " Silently ignore invalid buffers
    endtry
endfunction


function! s:DisableRustAutoLinting() " {{{2
    ALEDisableBuffer
endfunction

" {{{3
command! TmuxGdbBreak silent exec "!tmux send-keys -t \\! 'br ' " . expand('%:t') . ':' . line('.') . ' Enter'
command! TmuxGdbRun silent exec "!tmux send-keys -t \\! 'run' Enter"
command! TmuxGdbDisable silent exec "!tmux send-keys -t \\! 'dis' Enter"
function! TmuxGdbInput()
    let l:cmd = input('Enter gdb command: ')
    silent exec "!tmux send-keys -t \\! '".l:cmd."' Enter"
endfunction " }}}3


function! FoldNonSearch() " {{{2
    let l:l = line('.')
    let l:c = col('.')

    %foldclose!
    g//normal! zv

    call cursor(l:l, l:c)
endfunction

" cword highlight func {{{2
command! CwordHighlightGroup echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"


" Autocommands " {{{1
if has('autocmd') " {{{ 2
    filetype plugin indent on
    augroup shell
        autocmd!
        au BufNewFile,BufRead *.d set filetype=sh
    augroup END
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
    augroup END
else
    set autoindent " always set autoindenting on
endif


augroup jane-dispatch " {{{ 2
    autocmd!
    autocmd FileType rust let b:dispatch = 'cargo test'
    autocmd FileType go let b:dispatch = 'go build %'
    autocmd FileType cpp call SetupEnvironment()
augroup END


augroup format " {{{ 2
    autocmd!
    autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()
augroup END


augroup vader " {{{ 2
    autocmd!
    autocmd BufRead *.{vader,vim}
                \ command! -buffer Test call s:exercism_tests()
augroup END


augroup ProjectRootCD " {{{ 2
    autocmd!
    autocmd BufEnter * call <SID>AutoProjectRootCD()
augroup END

" color scheme stuff {{{1
set cursorline
if filereadable(expand('~/.vimrc_background'))
    let base16colorspace=256
    source ~/.vimrc_background
endif
colorscheme base16-default-dark

" highlight lines in Sy and vimdiff etc.)
" highlight link SignifyLineAdd             DiffAdd
" highlight link SignifyLineChange          DiffChange
" highlight link SignifyLineDelete          DiffDelete
" highlight link SignifyLineChangeDelete    SignifyLineChange
" highlight link SignifyLineDeleteFirstLine SignifyLineDelete
" highlight link SignifySignAdd             DiffAdd
" highlight link SignifySignChange          DiffChange
" highlight link SignifySignDelete          DiffDelete
" highlight link SignifySignChangeDelete    SignifySignChange
" highlight link SignifySignDeleteFirstLine SignifySignDelete
" highlight ALEErrorSign ctermfg=1 cterm=reverse
" highlight ALEWarningSign ctermfg=3 cterm=reverse
" highlight link ALEInfoSign SignColumn
" highlight ALEError cterm=reverse ctermfg=1
" highlight ALEWarning cterm=reverse ctermfg=3
" highlight link ALEInfo SpellBad
