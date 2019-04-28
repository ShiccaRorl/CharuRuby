# -*- encoding: utf-8 -*-

module Charu
  class Category
    attr_accessor :category
    def initialize()
      @category = []
      @config = Charu::Config.new()

      # プライベートの設定
      # 基本は全部プライベート
      @private_category = false
    end

    def add(title_source)
      if title_source == nil then
        title_source = ""
      end

      title_source.scan(/\[(.*?)\]:/).each{|category|
        @category << category[0]
      }
    end

    def get_category_list()
      @category.uniq! # 重複削除
      return @category
    end

    def get_public_category()
      @category.each{|category|
        @config.public_category.each{|public_category|
          if category == public_category then
            @public_category = true
          end
        }
      }
      return @public_category
    end

    def get_private_category()
      # プライベートの設定
      # パブリックのカテゴリーに指定したものだけ、公開することにしてあります。
      @category.each{|category|
        @config.public_category.each{|public_category|
          if category == public_category then
            @private_category = true
          end
        }
      }

      # プライベートの設定
      @category.each{|category|
        @config.private_category.each{|private_category|
          if category == private_category then
            @private_category = false
          end
        }
      }
      return @private_category
    end
  end

  class Item
    attr_accessor :date, :item_title_source, :item_log, :category
    def initialize(date)
      if date == nil then
        p "アイテム初期化失敗"
        date = Time.now
        title = "アイテム初期化失敗"
      end

      @date = date

      @item_title_source = title
      @item_log = ""

      # カテゴリー
      @item_private_list = []

      @category = Charu::Category.new()

    end

    def set_item_title_source(item_title_source)
      @item_title_source = item_title_source
      @category.add(@item_title_source)
    end

    def get_item_title()
      if @item_title_source != nil then
        i = @item_title_source.gsub(/\*\s/, "") # タイトルから[＊]削除
        i = i.gsub(/\[(.*?)\]:/, "") # タイトルからカテゴリ削除

        return i
      end
      return ""
    end

    def get_item_log()
      if @item_log != nil then
        @item_log.chomp!  # 文字列最後の改行削除
        @item_log.rstrip! # 文字列最後の空白削除
        @item_log.strip!  # 先頭と末尾の空白文字を除去

        #@item_log.gsub!(/(\r\n|\r\f\n|\r|\n)/, "</p>\n<p>")

        options = {
          filter_html:     true,
          hard_wrap:       true,
          space_after_headers: true,
        }

        extensions = {
          autolink:           true,
          no_intra_emphasis:  true,
          fenced_code_blocks: true,
        }

        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

        renderer = Redcarpet::Render::HTML.new(options)
        markdown = Redcarpet::Markdown.new(renderer, extensions)

        html = markdown.render(@item_log)#.html_safe


        #html = RDiscount.new(@item_log, :smart, :filter_html)

        html.gsub!(/(\r\n|\r\f\n|\r|\n)/, "</p>\n<p>")

        return html
      end
      return ""
    end

    def app_item_log(line)
      if line != "" or line != "\n" then
        @item_log = @item_log + "\n" + line
      end
    end

    # カテゴリーリスト
    def get_item_category()
      if @category == nil then
        return []
      end
      return @category.get_category_list()
    end

    # パブリックのフラグを返す
    def get_public_category()
      return @category.get_public_category
    end

    # プライベートのフラグを返す
    def get_private_category()
      return @category.get_private_category
    end

    # 日付を取得する
    def get_item_date_string()
      return @date.strftime("%Y-%m-%d")
    end

    def get_year()
      return @date.strftime("%Y")
    end

    def get_year_month()
      return @date.strftime("%Y-%m")
    end
  end

  class Entry
    attr_accessor :item_title, :item_log, :category, :item_source_date
    def initialize(item_source)
      @item_source_date = ""
      @item_source_contents = ""
      @item_source_date = item_source[0]       # 時間データ・ソース
      @item_source_contents = item_source[1]  # 内容データ

      if @item_source_contents == nil then
        @item_source_contents == ""
      end
    end

    def get_items() # 解析する
      @items = []
      item = nil
      # 一行づつ処理する
      @item_source_contents.split("\n").each{|line|
        if item == nil then
          item = Charu::Item.new(self.get_entry_time())
        end
        if line.match(/^\*\s.*?/) != nil or line.match(/^\t\*\s.*?/) != nil then
          item = Charu::Item.new(self.get_entry_time())
          @items << item
          item.set_item_title_source(line)
        else
          if line == nil then
            line = ""
          end
          item.app_item_log(line)
        end
      }
      return @items
    end

    def get_entry_time()    #@entry_date = Time.mktime($1.to_i, $2.to_i, $3.to_i)
      t = Time.now
      begin
        t = Time.mktime(@item_source_date.split(/-/)[0].to_i, @item_source_date.split(/-/)[1].to_i, @item_source_date.split(/-/)[2].to_i)
      rescue
        p "日付変換エラー".encode(Encoding::SJIS)
      end
      return t
    end
  end

  class ChangeLog
    attr_accessor :entrys
    def initialize(entry_source)

      entry_sources_split = entry_source.split(/(^\d\d\d\d-\d\d-\d\d)\s.*?\n/m)

      entry_sources_split.delete_at(0) # splitのゴミ処理

      i = 0
      s = 1
      entry_size = entry_sources_split.size / 2
      @entrys = []
      for t in 0..entry_size do
        entry_data = []
        entry_data = [entry_sources_split[i], entry_sources_split[s]]
        # エントリー日付                          # エントリー内容
        i = i + 2
        s = s + 2
        if entry_data[1] != nil then
          entry = Charu::Entry.new(entry_data)
          @entrys << entry
        end

      end
    end
  end
end

# プライベートと分ける
module Charu
  class ChangeLogPublic < ChangeLog
    def get_item()
      @item_list_private = Hash.new()

      # プライベート集計
      @entrys.each{|entry|
        necessary = []
        day_s = ""
        entry.get_items().each{|item|
          day_s = item.get_item_date_string()
          if item.get_private_category == true then
            necessary << item
          end
        }
        @item_list_private[day_s] = necessary
      }

      # 配列の[]のを集計
      delt = []
      @item_list_private.each{|key, item|
        if item == [] then
          delt << key
        end
      }

      # []を削除
      delt.each{|del|
        @item_list_private.delete(del)
      }
      return @item_list_private
    end
  end

  class ChangeLogPrivate < ChangeLog
    def get_item()
      @item_list_private = Hash.new()

      @entrys.each{|entry|
        necessary = []
        day_s = ""
        entry.get_items().each{|item|
          day_s = item.get_item_date_string()

          necessary << item

        }
        @item_list_private[day_s] = necessary
      }

      # 配列の[]のを集計
      delt = []
      @item_list_private.each{|key, item|
        if item == [] then
          delt << key
        end
      }

      # []を削除
      delt.each{|del|
        @item_list_private.delete(del)
      }
      return @item_list_private
    end
  end
end

module Charu
  class ChangeLogMemo
    def initialize(item_list)
      @config = Charu::Config.new()

      @item_list = item_list

    end

    # アイテム数
    def article_size_()
      return @item_list.size()
    end

    # ページ数
    def article_size_max()
      return @item_list.size() / @config.article_size
    end

    # アイテム数を５０個とかで取り出せる
    def article_size(item_list, cnt)
      # [000-049] cnt 1 (1-1)*50 1*50-1
      # [050-099] cnt 2 (2-1)*50 2*50-1
      # [100-149] cnt 3 (3-1)*50 3*50-1

      # ハッシュから配列に変換
      items = []
      item_list.each{|key, item|
        items << item
      }

      # 配列で処理
      i = [0, 0]
      i[0] = (cnt - 1) * @config.article_size
      i[1] = (cnt * @config.article_size) - 1

      s = i[0]
      t = []
      while items[s] != nil and s <= i[1] do
        t << items[s]
        s = s + 1
      end

      # 配列からハッシュに変換
      item_hash = Hash.new()
      t.each{|items|
        item_hash[items.first.get_item_date_string()] = items
      }
      return item_hash
    end

    # 並び替え
    def get_item_sort(cnt)
      return article_size( Hash[ @item_list.sort ], cnt)
    end

    # 逆順で並び替え
    def get_item_sort_reverse(cnt)
      return article_size( Hash[ @item_list.sort.reverse ], cnt)
    end

    # カテゴリーのカテゴリー数をハッシュで戻す
    def get_category_cnt()
      category_cnt = Hash.new()

      uniq_category_list = [] # 重複削除すみ
      uniq_category_list = self.get_category_list()

      uniq_category_list.each{|uniq_category|
        category_cnt[uniq_category] = @all_category_list.count(uniq_category)
      }

      return Hash[ category_cnt.sort ]
    end

    # カテゴリーを取得する
    def get_category_list()
      return @all_category_list.uniq()
    end

  end
end
