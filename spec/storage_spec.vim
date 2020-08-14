source $PWD/autoload/storage.vim

let v:errors = []

" Redefines a function whose name is 'a:name' using 'a:stub'.
function! Mock_function(name, stub) abort
  let l:text =<< trim EOF
    function! %s(...) abort closure
      return call(a:stub, a:000)
    endfunction
  EOF
  execute printf(join(l:text, "\n"), a:name)
endfunction

function! Get_stub(cmd, path, tempfile) abort
  silent execute 'edit' fnameescape(a:tempfile)
  " Delete the file content.
  silent execute 'normal! ggdG'
  silent execute 'normal! a' . 'bla bla' . "\<Esc>"
  silent execute 'write'
  setlocal nobuflisted
endfunction

call Mock_function('storage#get_cmd', funcref('Get_stub'))

" This testing function does not work at first time the script is sourced. The
" reason is explained in this link:
" https://stackoverflow.com/a/22633702/747872
function! Spec_storage_read() abort
  echo 'storage#read()'
  let current_buffer = @%
  let storage_dict = {}
  let storage_cmd = 's3cmd'
  let file_path = 's3://some-bucket/some-file'

  echo repeat(' ', 2) . 'when called twice for the same file'
  try
    call storage#read(storage_cmd, file_path, storage_dict)
    call storage#read(storage_cmd, file_path, storage_dict)
  catch
    call assert_true(v:exception)
  endtry
  echo repeat(' ', 4) . 'should not throw an error'

  silent exe 'edit' current_buffer
  silent exe 'bd!' file_path
  echo "\n"
endfunction

function! Spec_storage_current_file_extension() abort
  echo 'storage#current_file_extension()'
  echo repeat(' ', 2).'when current file is "storage_spec.vim"'
  let expected = 'vim'
  let actual = storage#current_file_extension()
  echo repeat(' ', 4).'should return "vim"'
  call assert_equal(expected, actual)
  echo "\n"
endfunction

function! Spec_storage_cmd_script() abort
  echo 'storage#cmd_script()'
  let expected = 'ls -al /tmp'
  let actual = storage#cmd_script('ls', '-al', '/tmp')
  echo repeat(' ', 2).'should return string joined by a space'
  call assert_equal(expected, actual)
  echo "\n"
endfunction

function! Spec_storage_last_string() abort
  echo 'storage#last_string(str)'
  let expected = '/'
  let actual = storage#last_string('s3://foo/')
  echo repeat(' ', 2).'should return a:str last string'
  call assert_equal(expected, actual)
  echo "\n"
endfunction

function! Spec_storage_errorformat() abort
  echo 'storage#errorformatted_string(val)'
  let expected = '%f(%l\,%c):%m'
  let actual = storage#errorformat()
  echo repeat(' ', 2).'should return '. '"'.expected.'"'
  call assert_equal(expected, actual)
  echo "\n"
endfunction

function! Spec_storage_errorformatted_string() abort
  echo 'storage#errorformatted_string(val)'
  let expected = 's3://foo/bar.md(1,1):12324'
  let actual = storage#errorformatted_string('2016-10-31 00:00 12324 s3://foo/bar.md')
  echo repeat(' ', 2).'should return storage#errorformat() style string'
  call assert_equal(expected, actual)
  echo "\n"
endfunction

call Spec_storage_read()
call Spec_storage_current_file_extension()
call Spec_storage_cmd_script()
call Spec_storage_last_string()
call Spec_storage_errorformat()
call Spec_storage_errorformatted_string()

echo len(v:errors).' failed'
if !empty(v:errors)
  echo join(v:errors, "\n")
endif
