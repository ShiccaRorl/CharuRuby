# -*- encoding: utf-8 -*-


module Charu
class FtpClariant
    def initialize()
  @config = Charu::Config.new()


  system("#{@config.wget_path} -r -l 3 -Rjpg,png,css,js,gif  -I /sp -X /sp/user -D #{@config.top_home_page}  -E #{@config.top_home_page}")

  sleep 20

  system("find #{@config.top_home_page} -type f > #{@config.top_home_page}.filelist.txt")

  end
end
end