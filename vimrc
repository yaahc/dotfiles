set t_Co=16
set nocompatible
" Load plugins that ship with Vim {{{1
runtime macros/matchit.vim
runtime ftplugin/man.vim

" Load bundled plugins {{{1
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'HiLinkTrace')
call add(g:pathogen_disabled, 'NesC-Syntax-Highlighting')
call add(g:pathogen_disabled, 'vim-colors-solarized')
call add(g:pathogen_disabled, 'vim-nerdtree')
call add(g:pathogen_disabled, 'vim-tagbar')
call add(g:pathogen_disabled, 'vim-ycm-generator')
call pathogen#infect()
call pathogen#helptags()

" Autocommands {{{1
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
else
    set autoindent		" always set autoindenting on
endif

" Allow for tmux borked ctrl arrow keys
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Preferences {{{1
" Behaviour {{{2
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

" Prevent the cursor from droping back one character after exiting insert mode
" as possible
let CursorColumnI = 0 "the cursor column position in INSERT
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

" Tab-completion in command-line mode
set wildmenu
set wildmode=longest:full
set completeopt=longest,menu,preview
let g:SuperTabLongestHighlight=1
let g:SuperTabDefaultCompletionType = "<c-n>"
" let g:SuperTabDefaultCompletionType = context
" enable this shit if I manage to set up omnicomplete correctly
let g:SuperTabLongestEnhanced = 1
set wildignore=*.pdf,*.fo,*.o,*.jpeg,*.jpg,*.png
set suffixes=.otl

" Appearance {{{2
set ruler
set showcmd
set laststatus=2
set listchars=tab:▸\ ,trail:•
set list
",eol:¬
set relativenumber
set number
" When the terminal has colors, enable syntax+search highlighting
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif
set foldlevelstart=99

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
" Disable swapfile and backup {{{2
set nobackup
set noswapfile
" }}}

" Mappings {{{1

" Commands to quickly set >1 option in one go {{{2
command! -nargs=* Wrap set wrap linebreak nolist
command! -nargs=* Maxsize set columns=1000 lines=1000
" " Window switching {{{2
" nnoremap <C-k> <C-W>k
" nnoremap <C-j> <C-W>j
" nnoremap <C-h> <C-W>h
" nnoremap <C-l> <C-W>l
" File opening {{{2
" Shortcuts for opening file in same directory as current file
cnoremap <expr> %%  getcmdtype() == ':' ? escape(expand('%:h'), ' \').'/' : '%%'

" Fix the & command in normal+visual modes {{{2
nnoremap & :&&<Enter>
xnoremap & :&&<Enter>
" Crude visualmode-only mappings for block level XML tags {{{2
nnoremap viT vitVkoj
nnoremap vaT vatV
" Strip trailing whitespace {{{2
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
" Escape and paste a register {{{2
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
" Custom commands {{{1
function! Foo()
    call system('sleep 2')
endfunction
" :Stab {{{2
" Set tabstop, softtabstop and shiftwidth to the same value
" From http://vimcasts.org/episodes/tabs-and-spaces/
command! -nargs=* Stab call Stab()
function! Stab()
    let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if l:tabstop > 0
        let &l:sts = l:tabstop
        let &l:ts = l:tabstop
        let &l:sw = l:tabstop
    endif
    call SummarizeTabs()
endfunction

function! SummarizeTabs()
    try
        echohl ModeMsg
        echon 'tabstop='.&l:ts
        echon ' shiftwidth='.&l:sw
        echon ' softtabstop='.&l:sts
        if &l:et
            echon ' expandtab'
        else
            echon ' noexpandtab'
        end
    finally
        echohl None
    endtry
endfunction
" :CloseHiddenBuffers {{{2
" Wipe all buffers which are not active (i.e. not visible in a window/tab)
" Using elements from each of these:
"   http://stackoverflow.com/questions/2974192
"   http://stackoverflow.com/questions/1534835
command! -nargs=* Only call CloseHiddenBuffers()
function! CloseHiddenBuffers()
    " figure out which buffers are visible in any tab
    let visible = {}
    for t in range(1, tabpagenr('$'))
        for b in tabpagebuflist(t)
            let visible[b] = 1
        endfor
    endfor
    " close any buffer that are loaded and not visible
    let l:tally = 0
    for b in range(1, bufnr('$'))
        if bufloaded(b) && !has_key(visible, b)
            let l:tally += 1
            exe 'bw ' . b
        endif
    endfor
    echon "Deleted " . l:tally . " buffers"
endfun
" Plugin configuration {{{1
" textobj-entire {{{2
" textobj-entire defines: ie/ae maps
" Instead, use:           ia/aa
let g:textobj_entire_no_default_key_mappings = 1
xmap aa  <Plug>(textobj-entire-a)
omap aa  <Plug>(textobj-entire-a)
xmap ia  <Plug>(textobj-entire-i)
omap ia  <Plug>(textobj-entire-i)
" Fugitive.vim {{{2
if has("autocmd")

    " Auto-close fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete

    " Navigate up one level from fugitive trees and blobs
    autocmd User fugitive
                \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
                \   nnoremap <buffer> .. :edit %:h<CR> |
                \ endif

endif

" Add git branch to statusline.
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" Space.vim {{{2
let g:space_disable_select_mode=1
let g:space_no_search = 1

" highlight lines in Sy and vimdiff etc.)

highlight DiffAdd           cterm=bold ctermbg=none ctermfg=2
highlight DiffDelete        cterm=bold ctermbg=none ctermfg=1
highlight DiffChange        cterm=bold ctermbg=none ctermfg=3

" commentary adjustment
autocmd FileType c,h,cpp,hpp,cs,java setlocal commentstring=//\ %s

" fixing search highlighting
hi Search cterm=NONE ctermfg=black ctermbg=yellow

set tags+=tags;/

" ripgrep
set grepprg=rg\ --vimgrep

" fzf
map <C-p>~ :Files ~<CR>
map <C-p>s :Files ~/svn<CR>
map <C-p>g :Files ~/git<CR>
map <C-p>b :Files ~/seahawk<CR>

map <C-p> :Files<CR>

" easytags
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_auto_highlight = 0
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

" Syntastic
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_cpp_include_dirs = ['/home/jlusby/seahawk/app/build/include']
let g:syntastic_cpp_check_header = 0
let g:syntastic_cpp_checkers = ['gcc', 'cppcheck']
let g:syntastic_python_checkers = ['python', 'prospector', 'pep8', 'pycodestyle', 'pyflakes', 'pep257', 'pydocstyle', 'pylint']
" let g:syntastic_python_prospector_args = "--strictness veryhigh"
let g:syntastic_sh_checkers = ['sh', 'shellcheck', 'bashate', 'checkbashisms']
let g:syntastic_zsh_checkers = ['zsh', 'sh/shellcheck']
" let g:syntastic_aggregate_errors = 1

let g:ycm_show_diagnostics_ui = 0

" gitv

highlight diffAdded ctermfg=darkgreen
highlight diffRemoved ctermfg=darkred

set lazyredraw

" Autopep8
let g:autopep8_max_line_length=79
let g:autopep8_aggressive=2

" tabs
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" To show all commands that start with leader type :map <leader>
" leader mappings
let mapleader = " "

" Ripgrep search word under cursor
nmap <leader>* :Rg<CR>

" gitv
nmap <leader>gv :Gitv --all<cr>
nmap <leader>gV :Gitv! --all<cr>
vmap <leader>gV :Gitv! --all<cr>

" Syntastic
nmap <leader>c :SyntasticReset<cr>
nmap <leader>h :lclose<cr>

" misc
" vs last edited buffer
nmap <leader>v :vs#<cr>
nmap <leader>t :tabe#<cr>

" Turn off list chars, aka trailing spaces and visible tabs
nmap <silent> <leader>l :set list!<CR>
" Turn off search highlighting
nmap <silent> <leader>n :silent :nohlsearch<CR>

nmap <leader>ew :e %%
nmap <leader>es :sp %%
nmap <leader>ev :vsp %%
nmap <leader>et :tabe %%

" Prompt to open file with same name, different extension
nmap <leader>er :e <C-R>=expand("%:r")."."<CR>

" Gundo.vim {{{2
nmap <leader>u :GundoToggle<CR>

" Pydocstring
nmap <silent> <leader>D <Plug>(pydocstring)
