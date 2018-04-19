# -*- encoding: utf-8 -*-

require "Charu/version"
require 'bundler'

Bundler.require

require_relative 'Charu/ChangeLogMemo'

module Charu
  # Your code goes here...

end

if nil != ARGV[0] then
  changelogmemo = Charu::ChangeLogMemo.new(ARGV[0])
  p changelogmemo.get_item_sort_reverse()
end