source $PWD/autoload/storage.vim

let v:errors = []

function! Spec_storage_is_storage_path() abort
  echo 'storage#is_storage_path'
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

call Spec_storage_is_storage_path()

function! Spec_storage_has_cmd() abort
  echo 'storage#has_cmd'
  echo repeat(' ', 2).'when has cmd'
  let cmd = 's3cmd'
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

call Spec_storage_has_cmd()

echo "\n".len(v:errors).' failed'
if !empty(v:errors)
  echo join(v:errors, "\n")
endif
