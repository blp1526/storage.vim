if exists('g:loaded_storage')
  finish
endif
let g:loaded_storage = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:storage_vim_cmd')
  let g:storage_vim_cmd = 's3cmd'
endif

augroup storage
  autocmd!
  autocmd BufNewFile,BufRead s3://* call storage#get()
  " autocmd BufWritePre s3://* call storage#put()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
