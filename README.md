# storage.vim

## Usage

```markdown
$ vim s3://BUCKET/OBJECT
```

This executes `s3cmd get s3://BUCKET/OBJECT tempfile`, and shows the result as a new buffer.

```markdown
$ vim s3://BUCKET/OBJECT/
```

This executes `s3cmd ls s3://BUCKET/OBJECT/`, and shows the result as a quickfix window.

## Requirement

The `s3cmd` cli tool, or a same `get`, `put` and `ls` interfafce cli tool.

## Contributing

1. Fork it ( https://github.com/blp1526/storage.vim/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request
