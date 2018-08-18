# -*- encoding: utf-8 -*-

if "debug" == ARGV[0] then
  require 'Charu/Config'
  require 'Charu/ChangeLogMemo'
  require 'Charu/CreateHtml'
  require 'Charu/FTP'
  require 'Charu/Debug'

  debug = Charu::Debug.new()

  #debug.changelogmemo()
  #debug.createhtml()
  debug.ftp()

else

  require "Charu/version"
  require 'bundler'

  Bundler.require

  require 'redcarpet'

  require 'Charu/ChangeLogMemo'
  require 'Charu/Config'
  require 'Charu/Template'
  require 'Charu/CreateHtml'
  require 'Charu/FTP'
  #require 'Charu/Sitemap'

  module Charu
    # Your code goes here...

  end

  config = Charu::Config.new()

  source = ""
  # ChangeLogMemoファイル
  File.open(config.change_log_path, 'r:utf-8'){|f|
    source = f.read  # 全て読み込む
  }

  change_log_public = Charu::ChangeLogPublic.new(source)

  item_list_public = change_log_public.get_item()

  changelogmemo = Charu::ChangeLogMemo.new(item_list_public)
  page_counter = Charu::PageCounter.new(changelogmemo)
  page_counter.create_html(false)

  ftp_clariant = Charu::FtpClariant.new()
  ftp_clariant.put_file()

  # プライベートモード作成
  if config.private_mode == true then
    change_log_private = Charu::ChangeLogPrivate.new(source)

    item_list_private = change_log_private.get_item()

    changelogmemo = Charu::ChangeLogMemo.new(item_list_private)
    page_counter = Charu::PageCounter.new(changelogmemo)
    page_counter.create_html(config.private_mode)
  end

end
