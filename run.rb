require 'fb_graph'
require 'colorize'
require './parse_facebook.rb'

# token 常過期
ACCESS_TOKEN = 'CAACEdEose0cBAF38WACX0UWxNyDqmIknxkbUTfL2N9RnItoBEQggIWQZCMoRLkq2MLsZADZCKn109gZAU3gxcnzLBkPTm6SgAvZBg6CZAv3PqbyoUgRZCjv9xkvJMxmdD3JCjBXMfq8bzrf3ir30ypYDoovFJrMm8mlxg5hdCZC8AcSJSbNwS6NdJ3uZAMrUa25rMZCrgsjG6heQZDZD'

# 設定Timeout 時間
FbGraph.http_config do |http_client|
  http_client.connect_timeout = 120
end
fg = FbGraph::Page.fetch('THSRforsale', access_token: ACCESS_TOKEN) 


posts = fg.posts
post_count = 0
# LOGGER = Logger.new('xxx.log')
loop do
  begin
    posts.each do |post|
      # 不抓沒有回覆的文章
      next if post.comments.blank?
      post_count += 1
      puts "#{post.raw_attributes['message'].at(0..10).gsub(/\n/, '')} ...".red
      puts "Post Created Time: #{post.created_time.strftime('%Y-%m-%d %H:%M:%S')}".yellow
      # puts "Comments Count: #{post.comments.count}".blue
      ParseFacebook.parase_comments(post.comments)
      ParseFacebook.get_likes(post.likes)
      puts '----------------------------------------'
    end
    
    posts = posts.next
    break if posts.blank?
  rescue HTTPClient::ConnectTimeoutError
    puts '########## Timeout ##########'.red
    retry
  end
end

puts '-----------------End--------------------'
puts "Post Count: #{post_count}".yellow
File.open('facebook_users.txt', 'w') { |file| file.write(ParseFacebook.get_users.join("\n")) }

