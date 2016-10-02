function! storage#get(path, dict) abort
  let tmpfile = tempname()
  let a:dict[tmpfile] = a:path
  execute 'edit' fnameescape(tmpfile)
endfunction

function! storage#put() abort
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
