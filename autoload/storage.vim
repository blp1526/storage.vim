function! storage#is_storage_path(path) abort
  if match(a:path, 's3://') == 0
    return 'true'
  else
    return 'false'
  endif
endfunction

function! storage#has_cmd(cmd) abort
  let script = 'which ' . a:cmd
  let result = system(script)
  if !v:shell_error
    return 'true'
  else
    return 'false'
  endif
endfunction

function! storage#get_cmd(path) abort
endfunction

function! storage#put_cmd(path) abort
endfunction
