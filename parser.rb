require 'fb_graph'
require 'colorize'

# token 常過期
ACCESS_TOKEN = 'CAACEdEose0cBAGOZC88xswv3WdazBqncWW40cvGF4Ar1xZCdmLimGZArRwsxX1Atm2Ip1DhM5WEiAhLXOAnYZANnBn9HkQMQWPWSDG3rtS1kQmpVHutbhO7amKsZCcN3FWxH4D5ItFbNyUNGBJvp6EqrqpTtubktjljjT9t9fawtofhYuFG3v1tOZBsai9N7Irtc8Q9Hf6gAZDZD'
fg = FbGraph::Page.fetch('THSRforsale', access_token: ACCESS_TOKEN)

posts = fg.posts
post_count = 0
users = {}
loop do
  posts.each do |post|
    # 不抓沒有回覆的文章
    next if post.comments.blank?
    post_count += 1
    puts "#{post.raw_attributes['message'][0..10]} ...".red
    puts "CreatedTime: #{post.created_time.strftime('%Y-%m-%d %H:%M:%S')}".yellow
    puts "Comments Count: #{post.comments.count}".blue

    post.comments.each do |comment|
      user = comment.raw_attributes['from']
      users[user['id']] = user['name']
    end
    puts '----------------------------------------'
  end
  
  posts = posts.next
  if posts.blank?
    puts '-----------------End--------------------'
    puts "Post Count: #{post_count}".yellow
    File.open('facebook_users.rtf', 'w') { |file| file.write(users) }
    break
  end
end