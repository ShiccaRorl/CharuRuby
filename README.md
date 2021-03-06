﻿# Charu

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/Charu`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem Charu
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install Charu

## Usage

### 必要なプログラム
```
sudo apt-get install lftp
```

### 初期化
```
./CharuConfig/CharuConfig.rb
```
設定してください。

### テンプレート
```
./CharuConfig/template/
```

### 実行
```
bundle exec Charu
```

### ChangeLogMemoとは？

[横着プログラミング 第1回: Unixのメモ技術](http://0xcc.net/unimag/1/)

[Change Log メモを試してみよう](http://at-aka.blogspot.jp/p/change-log.html)

パブリックの[Public]:のカテゴリーが付いていないもの以外はHTML化しないです。

FTPアップロードに「lftp」使っています。

CSSは[tDiary](http://www.tdiary.org/)のが使えます。

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/Charu. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Charu project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/Charu/blob/master/CODE_OF_CONDUCT.md).
