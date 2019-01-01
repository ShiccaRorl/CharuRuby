# -*- encoding: utf-8 -*-

require "erb"

module Charu
  class PageCounter
    def initialize(changelogmemo, entirey)
      @entirey = entirey
      changelogmemo = changelogmemo
      @max_page = changelogmemo.article_size_max()
      p "Page MAX " + @max_page.to_s

      i = 0
      @pages = []
      while i <= @max_page do
        if i == 0 then
          @pages << [[i, "index.html", changelogmemo.get_item_sort_reverse(1)]]
        else
          @pages << [[i, "index" + i.to_s + ".html", changelogmemo.get_item_sort_reverse(i)]]
        end
        p "Page " + i.to_s
        i = i + 1
      end
    end

    def create_html(mode)
      p mode
      p "pages.size " + @pages.size.to_s
      @pages.each{|page|
        create_html = Charu::CreateHtml.new(page, @pages.size, @entirey)
        if mode == true then
          create_html.create_body_private()
        elsif mode == false then
          create_html.create_body_public()
        end
      }

    end

  end

  class CreateHtml
    attr_accessor :keyword, :css_theme_path, :link, :hiduke, :day, :title, :config, :page, :page_max, :changelogmemo, :entirey
    def initialize(page, page_max, entirey)
      @config = Charu::Config.new()

      @entirey = entirey

      @page_max = page_max - 1
      @page = page

      @header          = File.open("./CharuConfig/template/header.erb").read
      @footer          = File.open("./CharuConfig/template/footer.erb").read
      @body            = File.open("./CharuConfig/template/body.erb").read
      @day_body        = File.open("./CharuConfig/template/day_body.erb").read
      @autoupload_lftp = File.open("./CharuConfig/autoupload.lftp").read

      self.keyword()
      #self.create_body_public()
      #self.create_body_private()
      self.lftp()
    end

    def keyword()
      @keyword = ""
      @config.home_category.each{|key|
        @keyword = "#{@keyword}, " + "#{key}"
      }
      return @keyword.encode!("UTF-8")
    end

    def create_body_private()
      # くっつける

      @htmls = []
      @page.each{|page, file_name, changelogmemo|
        p "page " + page.to_s + " 作成中"
        #p file_name
        @changelogmemo = changelogmemo

        @html = @header + @body + @footer
        #p changelogmemo

        erb = ERB.new(@html)

        @html = erb.result(binding)

        begin
          File.write(@config.www_html_out_path_private + file_name, @html)
        rescue
          p "書き込みエラー"
        end
      }
    end

    def create_body_public()
      # くっつける

      @htmls = []
      @page.each{|page, file_name, changelogmemo|
        p "page " + page.to_s + " 作成中"
        #p file_name
        @changelogmemo = changelogmemo

        @html = @header + @body + @footer
        #p changelogmemo

        erb = ERB.new(@html)

        @html = erb.result(binding)

        begin
          File.write(@config.www_html_out_path + file_name, @html)
        rescue
          p "書き込みエラー"
        end
      }
    end

    def create_day_body()
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
            File.write(@config.www_html_out_path + "index/" + day_s + ".html", html)
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
        File.write(@config.www_html_out_path + @file_name, ｈｔｍｌ)
      }
    end

    def lftp()
      erb = ERB.new(@autoupload_lftp)
      lftp = erb.result(binding)

      begin
        File.write("./CharuConfig/autoupload.lftp", lftp)
      rescue
        p "書き込みエラー"
      end
    end



  end
end
