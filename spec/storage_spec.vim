source $PWD/autoload/storage.vim

let v:errors = []

function! Spec_storage_extension() abort
  echo 'storage#current_file_extension()'
  echo repeat(' ', 2).'when current file is storage_spec.vim'
  let expected = 'vim'
  let actual = storage#current_file_extension()
  echo repeat(' ', 4).'should return vim'
  call assert_equal(expected, actual)
endfunction

function! Spec_storage_cmd_script() abort
  echo 'storage#cmd_script()'
  let expected = 'ls -al /tmp'
  let actual = storage#cmd_script('ls', '-al', '/tmp')
  echo repeat(' ', 2).'should return string joined by space'
  call assert_equal(expected, actual)
endfunction

call Spec_storage_extension()
call Spec_storage_cmd_script()

echo "\n".len(v:errors).' failed'
if !empty(v:errors)
  echo join(v:errors, "\n")
endif
