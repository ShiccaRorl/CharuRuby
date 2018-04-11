# -*- encoding: utf-8 -*-

module Charu
  class Item
    attr_accessor :datetime, :item_title, :item_log, :cotegory
    def initialize(time, title)
      log = ""
      if time == nil then
        p "アイテム初期化失敗"
        time = Time.now
        title = "アイテム初期化失敗"
      end

      @datetime = time

      @item_title = title
      @item_log = log

      @cotegory = []
      # カテゴリー
    end

    def get_item_title()
      if @item_title != nil then
        @item_title.gsub!(/\*\s/, "") # タイトルから[＊]削除
        @item_title.gsub!(/\[(.*?)\]:/, "") # タイトルからカテゴリ削除

        return @item_title
      end
      return ""
    end

    def get_item_log()
      if @item_log != nil then
        @item_log.chomp!  # 文字列最後の改行削除
        @item_log.rstrip! # 文字列最後の空白削除
        @item_log.strip!  # 先頭と末尾の空白文字を除去

        return @item_log
      end
      return ""
    end

    def get_item_category()
      if @cotegory == nil then
        return []
      end
      return @cotegory
    end
  end

  class Entry
    attr_accessor :datetime, :item_title, :item_log, :cotegory
    def initialize(item_source)
      @item_source_day = ""
      @item_source_contents = ""
      @item_source_day = item_source[0]       # 時間データ・ソース
      @item_source_contents = item_source[1]  # 内容データ

      if @item_source_contents == nil then

        @item_source_contents == ""
      end
    end

    def get_item_contents()
      @item_contents = []
      @item_source_contents.gsub(/^(\*\s.*?)\n(.*)/m){|i|
        if i == "" then
        elsif i == "\n" then
        else
          @item_contents << [$1, $2]
        end
      }

      items = []
      @item_source_contents.split("\n").each{|line|
        if line =~ /^\*\s.*?\n/ or line =~ /^\t\*\s.*?\n/ then
          if item == !il then
            items << item
            item = Item.new(@item_source_day, line)
            p line
          else
            item.app(line)
          end
        end
      }

      # 日付で分ける

=begin
        # 配列操作
        #@item_contents.uniq!       # 重複削除
        #item_contents.delete("*")  # "*" 削除
        #item_contents.delete("\n")  # "\n" 削除
        #@item_contents.delete([])  # [] 削除
        #@item_contents.delete("")  # "" 削除

        # 文字列操作
        @item_contents.each{|item_source|
          #p item_source.encode(Encoding::SJIS)

          if item_source.size != 0 then
            #p "===========item_source err==========="
            #p item_source.encode(Encoding::SJIS)
            #item_source.gsub!(/\n/, "")  # 文字列先頭の改行削除
            item_source.chomp!  # 文字列最後の改行削除
            item_source.rstrip! # 文字列最後の空白削除
            item_source.strip!  # 先頭と末尾の空白文字を除去
          else
            p "文字列操作エラー".encode(Encoding::SJIS)
          end
        }
=end

      return @item_contents
    end

    def get_items()

      # item_contents = 日付で分けたデータ
      # item_content = １日分
      # item_content = １日分をアイテムに分けたデーター
      @items = []
      get_item_contents().each{|item_title, item_content|
        items1 = []
        if item_title != nil or item_title != "" then
          #p @item_source_day + i.encode(Encoding::SJIS)
          if item_content == nil then
            item_content = ""
          end

          item = Item.new(get_entry_time(), item_title, item_content)
          @items << item

        end
      }

      return @items
    end

    def get_entry_time()    #@entry_datetime = Time.mktime($1.to_i, $2.to_i, $3.to_i)
      t = Time.now
      begin
        t = Time.mktime(@item_source_day.split(/-/)[0].to_i, @item_source_day.split(/-/)[1].to_i, @item_source_day.split(/-/)[2].to_i)
      rescue
        p "日付変換エラー".encode(Encoding::SJIS)
      end
      return t
    end
  end

  class ChangeLog
    def initialize(entry_source)
      @logger = Logger.new('./temp/ChangeLog.log', 5, 1024 * 10)

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
          entry = Entry.new(entry_data)
          @entrys << entry
        end

      end
    end

    def get_entrys()
      return @entrys
    end

    def get_category_list()
      p "リスト".encode(Encoding::SJIS)
      category_list = []
      @entrys.each{|entry|
        entry.get_items().each{|item|
          item.get_item_category().each{|category|
            category_list << category.get_category()
          }
        }
      }
      category_list.uniq!
      category_list.sort!{|a, b| a <=> b } # 並び替え
      category_list.delete("")

      return category_list
    end
  end

  class ChangeLogMemo

    def initialize()
      @db_file_name = ARGV[0]

    end
  end
end

