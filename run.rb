#!/usr/bin/env ruby
require 'fb_graph'
require 'colorize'
require './parse_facebook.rb'

def prompt(*args)
    print(*args)
    gets
end

# token 常過期
cache_file_path = '/tmp/.cache_token'
cache_token = if  File.exist?(cache_file_path) then File.read(cache_file_path) else '' end

puts "請輸入 Access Token，請至網址：https://developers.facebook.com/tools/explorer/145634995501895/?method=GET&path=me%3Ffields%3Did%2Cname&version=v2.2)"
if cache_token.gsub("\n", "") == ''
  ACCESS_TOKEN = prompt('Access Token?'.red)
else
  token = prompt("Access Token? 劉空白使用上次 Token: #{cache_token}".red)
  ACCESS_TOKEN = if token.gsub("\n", "") == '' then cache_token else token end
end
FAN_PAGE = prompt('Facebook 粉絲團名稱 (非網址)'.blue)

File.open(cache_file_path, 'w') { |file| file.write(ACCESS_TOKEN) }  

puts "開始搜集：#{FAN_PAGE} TOKEN: #{ACCESS_TOKEN}".yellow


# 設定Timeout 時間
FbGraph.http_config do |http_client|
  http_client.connect_timeout = 120
end
fg = FbGraph::Page.fetch(FAN_PAGE, access_token: ACCESS_TOKEN) 


posts = fg.posts
post_count = 0
# LOGGER = Logger.new('xxx.log')
loop do
  begin
    posts.each do |post|
      # 不抓沒有回覆的文章
      next if post.comments.blank?
      post_count += 1
      if post.raw_attributes['message'].nil?
        puts "No message ...".red
      else
        puts "#{post.raw_attributes['message'].at(0..10).gsub(/\n/, '')} ...".red
      end
      puts "Post Created Time: #{post.created_time.strftime('%Y-%m-%d %H:%M:%S')}".yellow
      # puts "Comments Count: #{post.comments.count}".blue
      ParseFacebook.parase_comments(post.comments)
      ParseFacebook.get_likes(post.likes)
    end
    
    posts = posts.next
    break if posts.blank?
  rescue HTTPClient::ConnectTimeoutError
    puts '########## Timeout ##########'.red
    retry
  rescue
    puts "Exceptions Stopped"
    break
  end
end

puts '-----------------End--------------------'
puts "Post Count: #{post_count}".yellow
File.open('facebook_users.txt', 'w') { |file| file.write(ParseFacebook.get_users.join("\n")) }

