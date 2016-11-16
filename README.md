# storage.vim

## Usage

```markdown
$ vim s3://BUCKET/OBJECT
```

This executes `s3cmd get s3://BUCKET/OBJECT tempfile`, and shows the result as a new buffer.<br>
If you `:w[rite]`, then `s3cmd put tempfile s3://BUCKET/OBJECT` is executed.

```markdown
$ vim s3://BUCKET/OBJECT/
```

This executes `s3cmd ls s3://BUCKET/OBJECT/`, and shows the result as a quickfix window.

## Screenshot

![s3cmd](https://cloud.githubusercontent.com/assets/1040576/20217208/1544c4b2-a862-11e6-90c6-91d4c3629c0e.png)

## Requirement

The [s3cmd](https://github.com/s3tools/s3cmd) cli tool, or a same `get`, `put` and `ls` interfafce cli tool.

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

## Contributing

1. Fork it ( https://github.com/blp1526/storage.vim/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
