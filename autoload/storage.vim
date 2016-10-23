function! storage#read(cmd, path, dict) abort
  let last_index_of_path = strchars(a:path) - 1
  let last_string_of_path = a:path[last_index_of_path]

  if (last_string_of_path !=? '/')
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
  else
    " let current_errorformat = &errorformat
    " let &errorformat = '%f'
    " let ls_result = storage#ls_cmd(a:cmd, a:path)
    " cexpr ls_result
    " copen
    " let &errorformat = current_errorformat
    echo 'Sorry, readdir is not implemented yet.'
  endif
endfunction

function! storage#write(cmd, dict, path) abort
  let tempfile = a:dict[a:path]
  let current_hidden = &hidden
  set hidden
  execute 'edit' fnameescape(tempfile)
  execute '%d'
  execute 'edit' fnameescape(a:path)
  execute '%yank'
  execute 'edit' fnameescape(tempfile)
  execute 'put'
  execute 'normal ggdd'
  execute 'write'
  call storage#put_cmd(a:cmd, tempfile, a:path)
  execute 'edit' a:path
  setlocal nomodified
  let &hidden = current_hidden
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

function! storage#ls_cmd(cmd, bucket) abort
  let script = a:cmd . ' ls ' . a:bucket
  return system(script)
  " if v:shell_error != 0
  " " TODO:
  " endif
endfunction

function! storage#current_file_extension() abort
  return expand('%:e')
endfunction
