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

  module Charu
    # Your code goes here...

  end

  createhtml = Charu::PageCounter.new()
  createhtml.create_html()

  ftp_clariant = Charu::FtpClariant.new()
  ftp_clariant.put_file()

end