function! storage#read(cmd, path, dict) abort
  let extension = storage#current_file_extension()
  let tempfile  = tempname() . '.' . extension
  let a:dict[a:path] = tempfile
  call storage#get_cmd(a:cmd, a:path, tempfile)
  execute 'edit' fnameescape(tempfile)
  execute '%yank'
  execute 'edit' fnameescape(a:path)
  execute 'put'
  execute 'normal ggdd'
  execute 'filetype detect'
endfunction

function! storage#write(cmd, dict, path) abort
  let tempfile = a:dict[a:path]
  set hidden
  execute 'edit' tempfile
  execute '%d'
  execute 'edit' a:path
  execute '%yank'
  execute 'edit' tempfile
  execute 'put'
  execute 'normal ggdd'
  execute 'write'
  call storage#put_cmd(a:cmd, tempfile, a:path)
  execute 'edit' a:path
endfunction

function! storage#get_cmd(cmd, bucket, file) abort
  let script = a:cmd . ' get ' . a:bucket . ' ' . a:file
  call system(script)
  if v:shell_error != 0
  " TODO:
  endif
endfunction

function! storage#put_cmd(cmd, file, bucket) abort
  let script = a:cmd . ' put ' . a:file . ' ' . a:bucket
  call system(script)
  if v:shell_error != 0
  " TODO:
  endif
endfunction

function! storage#current_file_extension() abort
  return expand('%:e')
endfunction
