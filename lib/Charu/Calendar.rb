# -*- encoding: utf-8 -*-

module Charu
  class ChangeLogMemo_Calendar
    attr_accessor :year, :all_category_list, :year_month
    def initialize(item_list)
      @config = Charu::Config.new()

      @item_list = item_list

      # 全てのカテゴリーを取得
      @all_category_list = []
      @item_list.each{|key, items|
        #p "key " + key
        #p items
        items.each{|item|
          item.get_item_category().each{|category|
            @all_category_list << category
          }
        }
      }

      #全ての年を取得
      @year = []
      @item_list.each{|key, items|
        items.each{|item|
          @year << item.get_year()
        }
      }
      @year.uniq!

      #カレンダーデータ作成
      @year_month = {}
      @item_list.each{|key, items|
        items.each{|item|
          if @year_month.select{|key2, data| item.get_year_month() == key2 } == {} then
            #p "1"
            @year_month[item.get_year_month()] = Year_Month.new()
            @year_month[item.get_year_month()].add_data(item)
          else
            #p "2"
            @year_month[item.get_year_month()].add_data(item)
          end
        }
      }

    end
  end

  class Year_Month
    def initialize()
       @data = []
    end
    def get_data()
      return @data
    end
    def add_data(data)
      @data << data
    end
  end
end