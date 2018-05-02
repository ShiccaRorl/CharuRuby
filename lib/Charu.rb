# -*- encoding: utf-8 -*-

require "Charu/version"
require 'bundler'

Bundler.require

require 'Charu/ChangeLogMemo'
require 'Charu/Config'
require 'Charu/Template'
require 'Charu/CreateHtml'
require 'Charu/FTP'


module Charu
  # Your code goes here...

end


  changelogmemo = Charu::ChangeLogMemo.new()
  changelogmemo.get_item_sort_reverse(1).each{|i|
    p i.datetime
    p i.get_item_title.encode(Encoding::SJIS)
    #p i.get_item_category()
  }
  p changelogmemo.get_category_list()
  p changelogmemo.get_category_cnt()