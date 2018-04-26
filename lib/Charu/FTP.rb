# -*- encoding: utf-8 -*-

require 'net/ftp'

module Charu
  class FtpClariant
    def initialize()
      @config = Charu::Config.new()

      @server = @config.server
      @port = @config.port
      @user = @config.user
      @pass = @config.pass
      @dir = @config.www_html_out_path

      @list = Dir.glob(@dir + '*.html')
    end

    def put_file()
      ftp = Net::FTP.new
      ftp.connect(@server, @port)
      ftp.login(@user, @pass)

      ftp.chdir('./')
      p "./  :初期ディレクトリ".encode(Encoding::SJIS)
      puts ftp.pwd

      file_list = []
      @list.each{|file|
        file_list << File::expand_path(file)
      }
      ftp.chdir(@dir)
      p @dir + ":移動ディレクトリ".encode(Encoding::SJIS)
      puts ftp.pwd

      # アップロード
      file_list.each{|file|
        p file
        ftp.put(file)
      }
      p "完了".encode(Encoding::SJIS)
      puts ftp.pwd

      ftp.quit
    end
  end
end
