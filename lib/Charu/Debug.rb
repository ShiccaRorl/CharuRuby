# -*- encoding: utf-8 -*-

module Charu
  class Debug
    def initialize()
      print "=====ディバックモード=====\n"
    end

    def changelogmemo()
      #changelogmemo = Charu::ChangeLogMemo.new()
      #changelogmemo.get_item_sort_reverse(1).each{|key, items|
      #items.each{|item|
      #p item.date
      #p item.get_item_title.encode(Encoding::SJIS)
      #p i.get_item_category()
      #}
      #}
      #p changelogmemo.article_size_max()
      #p changelogmemo.article_size_()
      #p changelogmemo.get_category_cnt()
    end

    def ftp()
      ftp_clariant = Charu::FtpClariant.new()
      ftp_clariant.put_file()
    end

    def createhtml()
    end

  end
end