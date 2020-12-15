# storage.vim

<img alt="storage.vim" src="https://user-images.githubusercontent.com/1040576/102196982-eb4bd780-3f03-11eb-91b9-2e16ad045ed0.jpg" width="640px">

## Usage

```markdown
$ vim s3://BUCKET/OBJECT/
```

This executes `s3cmd ls --recursive s3://BUCKET/OBJECT/` or `aws s3 ls --recursive s3://BUCKET/OBJECT/`, and shows the result as a quickfix window.

```markdown
$ vim s3://BUCKET/OBJECT
```

This executes `s3cmd get --force s3://BUCKET/OBJECT tempfile` or `aws s3 cp s3://BUCKET/OBJECT tempfile`, and shows the result as a new buffer.<br>
If you `:w[rite]`, then `s3cmd put tempfile s3://BUCKET/OBJECT` or `aws s3 cp tempfile s3://BUCKET/OBJECT` is executed.

## Requirement

[s3cmd](https://github.com/s3tools/s3cmd) or [aws-cli](https://github.com/aws/aws-cli)

## Option

```markdown
let g:storage_vim_cmd = 'aws s3'
```

Default g:storage_vim_cmd is s3cmd.

## Installation

Use your favorite plugin manager, or

```markdown
# at terminal
$ git clone https://github.com/blp1526/storage.vim.git ~/.vim/bundle/storage.vim
```

```markdown
# at .vimrc
set runtimepath^=~/.vim/bundle/storage.vim
```

```markdown
# at Vim
:helptags ~/.vim/bundle/storage.vim/doc
```

## Development

This repository's
[spec](https://github.com/blp1526/storage.vim/tree/master/spec) directory has
test code. If you want to run test code, open spec file with
`vim --clean spec/storage_spec.vim`, and exec `source %`.

## Contributing

1. Fork it ( https://github.com/blp1526/storage.vim/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
