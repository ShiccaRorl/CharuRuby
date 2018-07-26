# -*- encoding: utf-8 -*-

config = ""
config = '# -*- encoding: utf-8 -*-

module Charu
  class Config
    attr_accessor :home_title, :top_home_page, :home_category, :home_description, :css_theme_path, :private_category
    attr_accessor :change_log_path, :article_size, :www_html_out_path, :www_html_out_path_private, :public_category
    attr_accessor :ftp_server, :ftp_port, :ftp_user, :ftp_pass
	attr_accessor :wget_path
    def initialize()
      # ホームページタイトル
      @home_title = "TestPage"

      # ホームページトップ
      @top_home_page = "http://hoge.com/hoge/index.html"

      # ホームページカテゴリー
      @home_category = ["Ruby", "Python", "Java", "c++", "Ruby_on_Rails", "JavaSciript", "LIPS"]

      # ホームページのdescription
      @home_description = "日々勉強中"

      # CSS Path
      @css_theme_path = "./css/"

	  # プライベートカテゴリー
      @private_category = ["Private", "P", "★", "2ch", "5ch", "PS", "Life"]

	  # パブリックカテゴリー
      @public_category = ["Public"]
	  
      # Change_Log_path
      @change_log_path = "./../ChangeLog"

      # 一度に表示する記事数
      @article_size = 50

      # ｈｔｍｌの作成先
      @www_html_out_path = "./www/"

      # ｈｔｍｌの作成先 プライベート
      @www_html_out_path_private = "./Private/"

      # FTPの設定
      @ftp_server = ""
      @ftp_port = "21"
      @ftp_user = ""
      @ftp_pass = ""

      # Wgetのパス
      @wget_path = ""
	  
    end
  end
end

'

autoupload_lftp = ""
autoupload_lftp = '
<% require "./CharuConfig/CharuConfig" %>
<% config = Charu::Config.new() %>

open "<%= config.ftp_server %>" -p <%= config.ftp_port %> -u "<%= config.ftp_user %>","<%= config.ftp_pass %>"
cd   "./"
lcd  "<%= config.www_html_out_path %>"
mirror -R
'

# ディレクトリの確認
if Dir.exist?("./CharuConfig") == false then
  # ディレクトリの作成
  Dir.mkdir('CharuConfig')
end

if File.exist?("./CharuConfig/CharuConfig.rb") == false then
  File.open("./CharuConfig/CharuConfig.rb", "w:utf-8") do |f|
    f.puts(config)
  end
else
  require './CharuConfig/CharuConfig'
end


#autoupload_lftp
if File.exist?("./CharuConfig/autoupload.lftp") == false then
  File.open("./CharuConfig/autoupload.lftp", "w:utf-8") do |f|
    f.puts(autoupload_lftp)
  end
else

end



