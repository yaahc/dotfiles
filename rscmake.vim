" Author: Jane Lusby
" Description: rscmake for cpp files

call ale#Set('cpp_rscmake_executable', 'rscmake')
call ale#Set('cpp_rscmake_options', '')

function! ale_linters#cpp#rscmake#GetExecutable(buffer) abort
    return ale#Var(a:buffer, 'cpp_rscmake_executable')
endfunction

function! ale_linters#cpp#rscmake#GetCommand(buffer) abort
    let l:options = ale#Var(a:buffer, 'cpp_rscmake_options')

    return ale#Escape(ale_linters#cpp#rscmake#GetExecutable(a:buffer))
    \   . (!empty(l:options) ? ' ' . l:options : '')
    \   . ' %s'
endfunction

call ale#linter#Define('cpp', {
\   'name': 'rscmake',
\   'output_stream': 'both',
\   'executable_callback': 'ale_linters#cpp#rscmake#GetExecutable',
\   'command_callback': 'ale_linters#cpp#rscmake#GetCommand',
\   'callback': 'ale#handlers#gcc#HandleGCCFormat',
\   'lint_file': 1,
\})

