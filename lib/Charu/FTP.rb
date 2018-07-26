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
      @list.each{|file| # 絶対パスを取得する
        file_list << [File::expand_path(file) ,File.dirname(file)]
      }

      # ディレクトリかファイルか判断
      file_list.each{|file, dir|
        dir.sub!(@config.www_html_out_path, "")
        if FileTest.directory? file
          # ディレクトリのときの処理
          @dir_list << file

        elsif FileTest.file? file
          # ファイルのときの処理
          @file_list << [file, dir + "/"]
        else
          raise print('ファイルでもディレクトリでもない')
        end
      }
      #p @dir_list
      #p @file_list

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
      @file_list.each{|file, dir|
        #print file + "\n"
        #print dir + "\n"
       


        #ftp.put(file)
        #print "\n"
      }


command = "lftp -f ./CharuConfig/autoupload.lftp"
system(command)



      print "完了\n"
      puts ftp.pwd

      ftp.quit
    end
  end
end
