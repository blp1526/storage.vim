function! storage#read(cmd, path, dict) abort
  try
    if (storage#last_string(a:path) !=? '/')
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
      let &errorformat = storage#errorformat()
      let ls_result = storage#ls_cmd(a:cmd, a:path)
      let ls_result_array = split(ls_result, "\n")
      call map(ls_result_array, 'storage#errorformatted_string(v:val)')
      cgete join(ls_result_array, "\n")
      " FIXME: find better way
      setlocal nomodified
      copen
      let &errorformat = current_errorformat
    endif
  catch
  endtry
endfunction

function! storage#last_string(str) abort
  let last_index = strchars(a:str) - 1
  return a:str[last_index]
endfunction

function! storage#errorformat() abort
  return '%f(%l\,%c):%m'
endfunction

function! storage#errorformatted_string(val) abort
  let array = split(a:val)
  let file        = array[(len(array) - 1)]
  let line_column = '(1,1):'
  let message     = array[(len(array) - 2)]
  return (file . line_column . message)
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

function! storage#cmd_script(...) abort
  return join(a:000, ' ')
endfunction

function! storage#get_cmd(cmd, bucket, file) abort
  let script = storage#cmd_script(a:cmd, 'get', a:bucket, a:file)
  return storage#run_cmd(script)
endfunction

function! storage#put_cmd(cmd, file, bucket) abort
  let script = storage#cmd_script(a:cmd, 'put', a:file, a:bucket)
  return storage#run_cmd(script)
endfunction

function! storage#ls_cmd(cmd, bucket) abort
  let script = storage#cmd_script(a:cmd, 'ls', a:bucket)
  return storage#run_cmd(script)
endfunction

function! storage#run_cmd(script) abort
  let result =  system(a:script)
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
