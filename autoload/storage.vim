function! storage#read(cmd, path, dict) abort
  let extension = storage#current_file_extension()
  let tempfile = tempname()
  let tempfile  = tempfile . '.' . extension
  let a:dict[tempfile] = a:path
  call storage#get_cmd(a:cmd, a:path, tempfile)
  execute 'edit' fnameescape(tempfile)
  execute 'bdelete' fnameescape(a:path)
endfunction

function! storage#write() abort
endfunction

function! storage#has_cmd(cmd) abort
  let script = 'type ' . a:cmd
  call system(script)
  if !v:shell_error
    return 'true'
  else
    return 'false'
  endif
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
