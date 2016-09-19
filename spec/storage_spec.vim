source $PWD/autoload/storage.vim

let v:errors = []

function! Spec_storage_is_s3_path() abort
  echo 'storage#is_s3_path'
  echo repeat(' ', 2).'when path begins s3://'
  let path = 's3://foo/README.md'
  let expected = 'true'
  let actual = storage#is_s3_path(path)
  echo repeat(' ', 4).'should return true'
  call assert_equal(expected, actual)

  echo repeat(' ', 2).'when path does not begin s3://'
  let path = '/tmp/README.md'
  let expected = 'false'
  let actual = storage#is_s3_path(path)
  echo repeat(' ', 4).'should return false'
  call assert_equal(expected, actual)
endfunction

call Spec_storage_is_s3_path()

echo "\n".len(v:errors).' failed'
if !empty(v:errors)
  echo join(v:errors, "\n")
endif
