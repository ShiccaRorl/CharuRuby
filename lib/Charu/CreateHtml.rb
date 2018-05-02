# -*- encoding: utf-8 -*-

require 'redcarpet'

module Charu
  class CreateHtml
    def initialize()

      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)

      source= '

      # 見出し1
      ## 見出し2

      * リスト1
      * リスト2

      このサイトは[mukaer.com](http://mukaer.com)です。

      '

      puts markdown.render(source)

    end
  end
end