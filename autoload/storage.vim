function! storage#read(cmd, path, dict) abort
  let last_index_of_path = strchars(a:path) - 1
  let last_string_of_path = a:path[last_index_of_path]

  try
    if (last_string_of_path !=? '/')
      if (!has_key(a:dict, a:path))
        let tempfile  = tempname() . '.' . storage#current_file_extension()
        let a:dict[a:path] = tempfile
      endif
      call storage#get_cmd(a:cmd, a:path, tempfile)
      execute 'edit' fnameescape(tempfile)
      execute '%yank'
      execute 'edit' fnameescape(a:path)
      execute 'put'
      execute 'normal ggdd'
      execute 'filetype detect'
    else
      let current_errorformat = &errorformat
      let &errorformat = '%f'
      let ls_result = storage#ls_cmd(a:cmd, a:path)
      let ls_result_array = split(ls_result, "\n")
      call map(ls_result_array, 'storage#last_word(v:val)')
      cexpr join(ls_result_array, "\n")
      copen
      let &errorformat = current_errorformat
    endif
  catch
  endtry
endfunction

function! storage#last_word(val) abort
  let array = split(a:val)
  let index = len(array) - 1
  return array[index]
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
  try
    call storage#put_cmd(a:cmd, tempfile, a:path)
  catch
  endtry
  execute 'edit' a:path
  setlocal nomodified
  let &hidden = current_hidden
endfunction

function! storage#get_cmd(cmd, bucket, file) abort
  let script = a:cmd . ' get ' . a:bucket . ' ' . a:file
  let result =  system(script)
  if v:shell_error == 0
    return result
  else
    echo result
    throw 'Bad Exit Status Error'
  endif
endfunction

function! storage#put_cmd(cmd, file, bucket) abort
  let script = a:cmd . ' put ' . a:file . ' ' . a:bucket
  let result =  system(script)
  if v:shell_error == 0
    return result
  else
    echo result
    throw 'Bad Exit Status Error'
  endif
endfunction

function! storage#ls_cmd(cmd, bucket) abort
  let script = a:cmd . ' ls ' . a:bucket
  let result =  system(script)
  if v:shell_error == 0
    return result
  else
    echo result
    throw 'Bad Exit Status Error'
  endif
endfunction

function! storage#current_file_extension() abort
  return expand('%:e')
endfunction
