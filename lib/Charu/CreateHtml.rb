# -*- encoding: utf-8 -*-

#require 'redcarpet'

require "erb"

module Charu
  class Create_Day
    def initialize()

    end
  end

  class Create_Days
    def initialize()
      changelogmemo = Charu::ChangeLogMemo.new()
    end
  end
end

module Charu
  class Create_Category
    def initialize()

    end
  end

  class Create_Categorys
    def initialize()
      changelogmemo = Charu::ChangeLogMemo.new()
    end
  end
end

module Charu
  class CreateHtml
    def initialize()

      #markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

      source= '

      # 見出し1
      ## 見出し2

      * リスト1
      * リスト2

      このサイトは[mukaer.com](http://mukaer.com)です。

      '
      @config = Charu::Config.new()


      #puts markdown.render(source)
      @header   = File.open("./CharuConfig/template/header.erb").read
      @footer   = File.open("./CharuConfig/template/footer.erb").read
      @body     = File.open("./CharuConfig/template/body.erb").read
      @day_body = File.open("./CharuConfig/template/day_body.erb").read
    end

    def keyword()
      @keywords = @db[:keyword].select(:Keyword).all

      @keyword = ""
      @keywords.each{|i|
        i.each{|key, value|
          @keyword  = value + ", " + @keyword}
      }
      @keyword.encode!("UTF-8")
    end

    def create_body()
      # くっつける

      @htmls = []
      @days.get_days().each{|day|
        html = @header + @body + @footer
        @htmls << [day.get_day_s(), day.get_tile(), html] # くっつける
      }

      @htmls.each{|day_time, tile, body|
        erb = ERB.new(body)
        @htmls << [day_time, tile, erb.result(binding)] # ファイル名とｈｔｍｌの配列
      }
      file_save()
    end

    def day_create_body()
      @days.sort_data().each{|day_s| # 文字列だけのデータ
        @daydata = []
        @days.get_days.each{|day|
          if day_s == day.get_day_s() then
            @daydata << day
          else
            #@daydata << day
          end
          @daydata.sort!{|a, b| a.get_Datetime() <=> b.get_Datetime() }
          @css_path = "./../theme/"
          @css_theme_path = @css_path + @css_theme + "/" + @css_theme + ".css"
          htmls = @header + @body + @footer
          erb = ERB.new(htmls)
          html = erb.result(binding)
          # ファイル書き込み
          begin
            File.write(@thml_path + "index/" + day_s + ".html", html)
          rescue
            p day_s + ".html"
            p "ファイル書き込みエラー".encode(Encoding::SJIS)
          end
        }
      }
    end

    def file_save()
      # ファイル書き込み
      @days.get_days.each{|day_name, title, ｈｔｍｌ|
        File.write(@thml_path + @file_name, ｈｔｍｌ)
      }
    end
  end
end