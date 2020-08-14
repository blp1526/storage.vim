function! storage#read(cmd, path, dict) abort
  if (storage#last_string(a:path) !=? '/')
    if (!has_key(a:dict, a:path))
      let tempfile  = tempname()
      let a:dict[a:path] = tempfile
    else
      let tempfile = a:dict[a:path]
    endif
    call storage#get_cmd(a:cmd, a:path, tempfile)
    silent execute 'edit' fnameescape(tempfile)
    silent execute '%yank'
    setlocal nobuflisted
    silent execute 'edit' fnameescape(a:path)
    silent execute 'put'
    silent execute 'normal ggdd'
    silent execute 'filetype detect'
  else
    setlocal nomodified
    let ls_result = storage#ls_cmd(a:cmd, a:path)
    call storage#open_quickfix(ls_result)
  endif
endfunction

function! storage#write(cmd, dict, path) abort
  let tempfile = a:dict[a:path]
  let current_hidden = &hidden
  set hidden
  silent execute 'edit' fnameescape(tempfile)
  silent execute '%d'
  silent execute 'edit' fnameescape(a:path)
  silent execute '%yank'
  silent execute 'edit' fnameescape(tempfile)
  silent execute 'put'
  silent execute 'normal ggdd'
  silent execute 'write'
  setlocal nobuflisted

  echo storage#put_cmd(a:cmd, tempfile, a:path)

  silent execute 'edit' fnameescape(a:path)
  setlocal nomodified
  let &hidden = current_hidden
endfunction

function! storage#open_quickfix(ls_result) abort
  let current_errorformat = &errorformat
  let &errorformat = storage#errorformat()
  let ls_result_array = split(a:ls_result, "\n")
  call map(ls_result_array, 'storage#errorformatted_string(v:val)')
  let storage_vim_ls_list = join(ls_result_array, "\n")
  " FIXME: more beautify
  cgetexpr storage_vim_ls_list
  copen
  try
    " NOTE:
    " This 'colder' is required to prevent from throwing 'E925 Current quickfix was changed' error.
    " Because above 'cgetexpr' creates new quickfix, and current quickfix is changed.
    " See http://github.com/vim/vim/blob/0a9046fbcb33770517ab0220b8100c4494bddab2/src/quickfix.c#L2275-L2276
    silent colder
    let g:storage_vim_required_cnewer = 1
  catch
  endtry
  let &errorformat = current_errorformat
endfunction

function! storage#cnewer() abort
  if g:storage_vim_required_cnewer == 1
    silent cnewer
    let g:storage_vim_required_cnewer = 0
  endif
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

function! storage#current_line_string() abort
  return getline('.')
endfunction

function! storage#cmd_script(...) abort
  return join(a:000, ' ')
endfunction

function! storage#get_cmd(cmd, bucket, file) abort
  let script = storage#cmd_script(a:cmd, 'get --force', a:bucket, a:file)
  return storage#run_cmd(script)
endfunction

function! storage#put_cmd(cmd, file, bucket) abort
  let script = storage#cmd_script(a:cmd, 'put', a:file, a:bucket)
  call storage#run_cmd(script)
  return '"' . a:bucket . '" ' . 'uploaded'
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
    throw 'Bad Exit Status Error => ' . trim(result)
  endif
endfunction

function! storage#current_file_extension() abort
  return expand('%:e')
endfunction
