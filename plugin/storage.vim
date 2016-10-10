if exists('g:loaded_storage')
  finish
endif
let g:loaded_storage = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:storage_vim_cmd')
  let g:storage_vim_cmd = 's3cmd'
  let g:storage_vim_dict = {}
endif

augroup storage
  autocmd!
  autocmd BufReadCmd,FileReadCmd   s3://* call storage#read(g:storage_vim_cmd, @%, g:storage_vim_dict)
  autocmd BufWriteCmd,FileWriteCmd s3://* call storage#write(g:storage_vim_cmd, g:storage_vim_dict, @%)
  autocmd QuitPre                  s3://* execute 'quit!'
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
