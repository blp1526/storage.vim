source $PWD/autoload/storage.vim

let v:errors = []

function! Spec_storage_get() abort
  echo 'storage#get'
  echo repeat(' ', 2) . 'should return tempname()'
  let expected = '### pending ###'
  let actual = storage#get()
  call assert_equal(expected, actual)
endfunction

function! Spec_storage_is_storage_path() abort
  echo 'storage#is_storage_path()'
  echo repeat(' ', 2).'when path begins s3://'
  let path = 's3://foo/README.md'
  let expected = 'true'
  let actual = storage#is_storage_path(path)
  echo repeat(' ', 4).'should return true'
  call assert_equal(expected, actual)

  echo repeat(' ', 2).'when path does not begin s3://'
  let path = '/tmp/README.md'
  let expected = 'false'
  let actual = storage#is_storage_path(path)
  echo repeat(' ', 4).'should return false'
  call assert_equal(expected, actual)
endfunction

function! Spec_storage_has_cmd() abort
  echo 'storage#has_cmd()'
  echo repeat(' ', 2).'when has cmd'
  let cmd = 'type'
  let expected = 'true'
  let actual = storage#has_cmd(cmd)
  echo repeat(' ', 4).'should return true'
  call assert_equal(expected, actual)

  echo repeat(' ', 2).'when does not have cmd'
  let cmd = 'foo'
  let expected = 'false'
  let actual = storage#has_cmd(cmd)
  echo repeat(' ', 4).'should return false'
  call assert_equal(expected, actual)
endfunction

function! Spec_storage_extension() abort
  echo 'storage#current_file_extension()'
  echo repeat(' ', 2).'when current file is storage_spec.vim'
  let expected = 'vim'
  let actual = storage#current_file_extension()
  echo repeat(' ', 4).'should return vim'
  call assert_equal(expected, actual)
endfunction

function! Spec_storage_buffer_s3_path() abort
  echo 'storage#buffer_s3_path()'
  echo repeat(' ', 2).'when path is s3://foo.rb'
  let path = 's3://foo.rb'
  let expected = 's3:/foo.rb'
  let actual = storage#buffer_s3_path(path)
  echo repeat(' ', 4).'should return s3:/foo.rb'
  call assert_equal(expected, actual)
endfunction

" call Spec_storage_get()
call Spec_storage_is_storage_path()
call Spec_storage_has_cmd()
call Spec_storage_extension()
call Spec_storage_buffer_s3_path()

echo "\n".len(v:errors).' failed'
if !empty(v:errors)
  echo join(v:errors, "\n")
endif
