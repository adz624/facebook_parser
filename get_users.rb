require 'fb_graph'
require 'colorize'

# token 常過期
ACCESS_TOKEN = 'CAACEdEose0cBAFnqKTFBoNwTQ9R9bUxX7ujE6ZCn5HbCLCvZACoY2R4ZBvQJUsaKWlx0T2W9xlijh8Re4UIpMtaOKsl5CGraiZBh73Opar8GWoE1ZAKJzcolPH87lVLYNYx1RZAv31ZCS0tlhNEMf6xZAq3d8SCJybQE1tPD7FybDa33GtqXqE6V8yPc4AyDBy3ZAQhh8UuAXsgZDZD'
fg = FbGraph::Page.fetch('THSRforsale', access_token: ACCESS_TOKEN)

posts = fg.posts
post_count = 0
users_cache = {}
loop do
  posts.each do |post|
    # 不抓沒有回覆的文章
    next if post.comments.blank?
    post_count += 1
    # puts "#{post.raw_attributes['message'][0..10]} ...".red
    puts "CreatedTime: #{post.created_time.strftime('%Y-%m-%d %H:%M:%S')}".yellow
    puts "Comments Count: #{post.comments.count}".blue

    post.comments.each do |comment|
      user = comment.raw_attributes['from']
      users_cache[user['id']] = user['name']
    end
    puts '----------------------------------------'
  end
  
  posts = posts.next
  if posts.blank?
    puts '-----------------End--------------------'
    puts "Post Count: #{post_count}".yellow
    File.open('facebook_users.rtf', 'w') { |file| file.write(users_cache) }
    break
  end
end