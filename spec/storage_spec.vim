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

call Spec_storage_extension()

echo "\n".len(v:errors).' failed'
if !empty(v:errors)
  echo join(v:errors, "\n")
endif
