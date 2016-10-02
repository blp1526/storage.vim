function! storage#read(cmd, path, dict) abort
  let tempfile = tempname()
  " let a:dict[tmpfile] = a:path
  let extension = storage#current_file_extension()
  let tempfile  = tempfile . '.' . extension
  execute 'edit' fnameescape(tempfile)
  echo a:path
endfunction

function! storage#write() abort
endfunction

function! storage#is_storage_path(path) abort
  if match(a:path, 's3://') == 0
    return 'true'
  else
    return 'false'
  endif
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

function! storage#buffer_s3_path(s3_path) abort
  let path = substitute(a:s3_path, 's3://', '', '')
  return 's3:/' . path
endfunction

function! storage#get_cmd(cmd, bucket, file) abort
  let script = a:cmd . 'get ' . a:bucket . ' ' . a:file
  " TODO: shell_error > 0
  call system(script)
  " TODO: if match(a:file, '/') == 0, then a:file
  return $PWD . a:file
endfunction

function! storage#put_cmd(cmd, file, bucket) abort
  " TODO: shell_error > 0
  let script = a:cmd . 'put ' . a:file . ' ' . a:bucket
  call system(script)
  return $PWD . a:file
endfunction

function! storage#current_file_extension() abort
  return expand('%:e')
endfunction
