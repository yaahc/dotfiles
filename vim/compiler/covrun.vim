" Vim compiler file

if exists("current_compiler")
  finish
endif
let current_compiler = "covrun"

" CompilerSet makeprg=covrun
CompilerSet makeprg=covrun\ %:p
CompilerSet errorformat=%f:%l:%c:\ %m,%f:%l:\ Failure
