function! storage#is_s3_path(path) abort
  if match(a:path, 's3://') == 1
    return 'true'
  else
    return 'false'
  endif
endfunction
