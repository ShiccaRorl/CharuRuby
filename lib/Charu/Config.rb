# -*- encoding: utf-8 -*-

config = ""
config = '
# -*- encoding: utf-8 -*-

module Charu
  class Config
    attr_accessor :home_title, :top_home_page, :home_category, :home_description, :css_theme_path, :private_category
    attr_accessor :change_log_path, :article_size, :www_html_out_path, :www_html_out_path_private
    attr_accessor :ftp_server, :ftp_port, :ftp_user, :ftp_pass
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
      @private_category = ["Private", "P", "★", "2ch", "5ch"]

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

    end
  end
end

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

