# -*- encoding: utf-8 -*-

require 'net/ftp'

module Charu
  class FtpClariant
    def initialize()
      @config = Charu::Config.new()

      @server = @config.ftp_server
      @port = @config.ftp_port
      @user = @config.ftp_user
      @pass = @config.ftp_pass
      @dir = @config.www_html_out_path

      @list = Dir.glob(@dir + './**/*')
      @file_list = []
      @dir_list = []

    end

    def put_file()
      # 相対パスから絶対パスへ
      file_list = []
      @list.each{|file|
        file_list << File::expand_path(file) # 絶対パスを取得する
      }

      # ディレクトリかファイルか判断
      file_list.each{|file|
        if FileTest.directory? file
          # ディレクトリのときの処理
          @dir_list << file

        elsif FileTest.file? file
          # ファイルのときの処理
          @file_list << file
        else
          raise print('ファイルでもディレクトリでもない')
        end
      }
      p @dir_list
      p @file_list

      ftp = Net::FTP.new
      ftp.connect(@server, @port)
      ftp.login(@user, @pass)

      ftp.chdir('./')
      print "./  :初期ディレクトリ\n"
      puts ftp.pwd

      #ftp.chdir(@dir)
      #print @dir + ":移動ディレクトリ\n"
      #puts ftp.pwd

      # アップロード
      @file_list.each{|file|
        p file
        ftp.put(file)
      }
      print "完了\n"
      puts ftp.pwd

      ftp.quit
    end
  end
end
