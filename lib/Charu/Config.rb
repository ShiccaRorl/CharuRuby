# -*- encoding: utf-8 -*-

module Charu
class Config
def initialize()
# ホームページタイトル
@home_title = "TestPage"

# ホームページトップ
@top_home_page = "http://hoge.com/hoge/"

# ホームページカテゴリー
@home_category = ["Ruby", "Python", "Java"]

# ホームページのdescription
@home_description = "日々勉強中"

# CSS Path
@css_theme_path = "./css"

# プライベートカテゴリー
@Private_category = ["Private", "P", "★", "2ch"]

# Change_Log_path
@Change_Log_path = "./../Change_Log"

# 一度に表示する記事数
@article_size = 50

end
end
end