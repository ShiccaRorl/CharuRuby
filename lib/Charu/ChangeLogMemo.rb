# -*- encoding: utf-8 -*-

module Charu
  class Cotegory
    def initialize(title)
      if title == nil then
        title = ""
      end
      @category = []
      title.scan(/\[(.*?)\]:/).each{|i|
        self.add(i)
      }
    end

    def add(category)
      if category == nil then
        category = []
      end
      category.each{|i|
        @category << i
      }
    end

    def get_category_list()
      @category.uniq! # 重複削除
      return @category
    end
  end

  class Item
    attr_accessor :datetime, :item_title_source, :item_log, :cotegory
    def initialize(time)
      if time == nil then
        p "アイテム初期化失敗"
        time = Time.now
        title = "アイテム初期化失敗"
      end

      @datetime = time

      @item_title_source = title
      @item_log = ""

      # カテゴリー
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

        return @item_log
      end
      return ""
    end

    def app_item_log(line)
      if line != "" or line != "\n" then
        @item_log = @item_log + "\n" + line
      end
    end

    def get_item_category()
      @cotegory = Cotegory.new(@item_title_source)
      if @cotegory == nil then
        return []
      end
      return @cotegory.get_category_list()
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

    def get_items() # 解析する

      @items = []
      item = nil
      # 一行づつ処理する
      @item_source_contents.split("\n").each{|line|
        if item == nil then
          item = Item.new(@item_source_day)
        end
        if line.match(/^\*\s.*?/) != nil or line.match(/^\t\*\s.*?/) != nil then
          item = Item.new(@item_source_day)
          @items << item
          item.item_title_source = line
        else
          if line == nil then
            line = ""
          end
          item.app_item_log(line)
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
          entry = Entry.new(entry_data)
          @entrys << entry
        end

      end
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

  class ChangeLogPrivate < ChangeLog

  end

  class ChangeLogPublic < ChangeLog

  end

  class ChangeLogMemo
    def initialize()
      @config = Charu::Config.new()

      # ChangeLogMemoファイル
      File.open(@config.Change_Log_path, 'r:utf-8'){|f|
        @source = f.read  # 全て読み込む
      }

      @change_log_private = ChangeLogPrivate.new(@source)

      @item_list = []
      @change_log_private.entrys.each{|date|
        date.get_items().each{|item|
          @item_list << item
        }
      }

      @all_category_list = []
      @item_list.each{|item|
        item.get_item_category().each{|category|
          @all_category_list << category
        }
      }

=begin
      @change_log_private.entrys.each{|date|
        date.get_items().each{|item|
          p "======="
          p date.get_items().size
          p item.datetime
          p item.get_item_title().encode(Encoding::SJIS)
          p item.get_item_log().encode(Encoding::SJIS)
          #p item
        }
      }
=end
    end

    # アイテム数
    def article_size_max()

      return @item.size()
    end

    # アイテム数を５０個とかで取り出せる
    def article_size(item_list, cnt)
      # [000-049] cnt 1 (1-1)*50 1*50-1
      # [050-099] cnt 2 (2-1)*50 2*50-1
      # [100-149] cnt 3 (3-1)*50 3*50-1

      i = [0, 0]
      i[0] = (cnt - 1) * @config.article_size
      i[1] = (cnt * @config.article_size) - 1

      s = i[0]
      t = []
      while item_list[s] != nil and s <= i[1] do
        t << item_list[s]
        s = s + 1
      end

      return t
    end

    # 並び替え
    def get_item_sort(cnt)
      @item_list.sort!{|a, b| a.datetime <=> b.datetime }
      return self.article_size(@item_list, cnt)
    end

    # 逆順で並び替え
    def get_item_sort_reverse(cnt)
      @item_list.sort!{|a, b| b.datetime <=> a.datetime }
      return self.article_size(@item_list, cnt)
    end

    # カテゴリーのカテゴリー数を配列で戻す
    def get_category_cnt()
      category_cnt = []

      uniq_category_list = [] # 重複削除すみ
      uniq_category_list = get_category_list()

      uniq_category_list.each{|uniq_category|
        category_cnt << [uniq_category, @all_category_list.count(uniq_category)]
      }

      return category_cnt
    end

    # カテゴリーを取得する
    def get_category_list()
      return @all_category_list.uniq()
    end
  end
end

