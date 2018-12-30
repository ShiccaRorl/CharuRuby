# -*- encoding: utf-8 -*-

header = ""
header = '<!doctype html>
<html><head>
  <meta charset = "utf-8">
  <meta name="name" content="content">
  <meta http-equiv="Content-Style-Type" content="text/css">
  <meta http-equiv="Content-Script-Type" content="text/javascript">
  <meta http-equiv="Last-Modified" content="<%= Time.now().strftime("%Y-%m-%d %H:%M:%S") %> GMT">
  <meta name="keywords" content="<%= @keyword %> ">
  <meta name="description" content="<%= @config.home_description() %>">
    <link rel="stylesheet" href="theme/base.css" type="text/css" media="all">
  <link rel="stylesheet" href="<%= @config.css_theme_path %>" title="<%= @config.home_title %>" type="text/css" media="all">
  <title><%= @config.home_title %></title>

    <style type="text/css">
        .title{
              font-size: 30pt;
             }
        .page{
              font-size: 20pt;
              clear: both;
             }
        code{
              font-size: 20pt;
              color: white;
              background-color: #FFFFFF;
             }
         a:visited{
              color: #FF0000;
             }
         #page_a{
              font-size: 30pt;
              color: black;
              }
         .menu{
              font-size: 25pt;
              width: 20%;
              float: left;
              }
         .reset{
              clear: both;
               }
         .left1{
              width: 20%;
              float: left;
              }
         .left2{
              width: 80%;
              float: left;
              }
    </style>

</head>

<body>
<a class= "title" href="<%= @config.top_home_page %>"><p style="text-align: center"><%= @config.home_title %></p></a>
<hr>
'

body = ""
body = '
<center class="page">
<a href="./index.html" id="page_a">1</a>
<% i = 1 %>
<% while i < @page_max - 1 do %>
<a href="./index<%= i + 1 %>.html" id="page_a"><%= i + 1 %></a>
<% i = i + 1 %>
<% end %>
<p>ページ</p>
</center>

<div class="left1"><p> </p></div>
<div class="menu"><a href="./book/index.html">Book</a></div>
<div class="menu"><a href="./freesoft/index.html">FreeSoft</a></div>
<div class="menu"><a href="./Software/index.html">Software</a></div>
<div class="menu"><a href="./JW_CAD/index.html">JW_CAD</a></div>

<div class="reset"></div>

<div class="left1">

<% @changelogmemo.each{|key, items| %>
  <% items.each{|item| %>
    <%= item.get_year() %>
  <% } %>
<% } %>


</div>

<div class="left2">

<% @changelogmemo.each{|key, items| %>
  <% items.each{|item| %>
    <h2><span class="title">
    <%= item.get_item_title() %></h2>
    <p style="text-align: right"><%= item.date.strftime("%Y年%m月%d日 (%A)") %></p>

    <p><%= item.get_item_log() %></p>
  <% } %>
<% } %>

</div>

<center class="page">
<a href="./index.html">1</a>
<% i = 1 %>
<% while i < @page_max - 1 do %>
<a href="./index<%= i + 1 %>.html"><%= i + 1 %></a>
<% i = i + 1 %>
<% end %>
<p>ページ</p>
</center>
'

day_body = ""
day_body = '

<a href="./index.html"><h1><%= @title %></h1></a>
<br>
<body>

<center class="page">
<a href="./index.html">1</a>
<% i = 1 %>
<% while i < @page_max - 1 do %>
<a href="./index<%= i + 1 %>.html"><%= i + 1 %></a>
<% i = i + 1 %>
<% end %>
<p>ページ</p>
</center>

<% @days.each{|day| %>
<h2><span class="title">
<% link = "日記" %>
<a href="./main/index/<%= link = day[:Datetime].strftime("%Y%m%d") %>.html"><%= day[:Title] %></a></span></h2>
<div class="lm"><span class="lm">Last Update: <%= hiduke = day[:Datetime].strftime("%Y-%m-%d %H:%M:%S %A") %></span></div>
<p><%= day[:Log] %></p>
<% } %>

<center class="page">
<a href="./index.html">1</a>
<% i = 1 %>
<% while i < @page_max - 1 do %>
<a href="./index<%= i + 1 %>.html"><%= i + 1 %></a>
<% i = i + 1 %>
<% end %>
<p>ページ</p>
</center>

</body>
'

footer = ""
footer = '
</body>
<hr>
<p style="text-align: center"><%= Time.now.strftime("%Y-%m-%d %H:%M:%S (%A)") %></p>
</html>
'

# ディレクトリの確認
if Dir.exist?("./CharuConfig/template") == false then
  # ディレクトリの作成
  Dir.mkdir('CharuConfig/template')
end

# header
if File.exist?("./CharuConfig/template/header.erb") == false then
  File.open("./CharuConfig/template/header.erb", "w:utf-8") do |f|
    f.puts(header)
  end
else
  @header   = File.open("./CharuConfig/template/header.erb").read
end

# footer
if File.exist?("./CharuConfig/template/footer.erb") == false then
  File.open("./CharuConfig/template/footer.erb", "w:utf-8") do |f|
    f.puts(footer)
  end
else
  @footer   = File.open("./CharuConfig/template/footer.erb").read
end

# body
if File.exist?("./CharuConfig/template/body.erb") == false then
  File.open("./CharuConfig/template/body.erb", "w:utf-8") do |f|
    f.puts(body)
  end
else
  @body     = File.open("./CharuConfig/template/body.erb").read
end

# day_body
if File.exist?("./CharuConfig/template/day_body.erb") == false then
  File.open("./CharuConfig/template/day_body.erb", "w:utf-8") do |f|
    f.puts(day_body)
  end
else
  @day_body = File.open("./CharuConfig/template/day_body.erb").read
end
