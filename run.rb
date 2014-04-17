require 'fb_graph'
require 'colorize'
require './parse_facebook.rb'

# token 常過期
ACCESS_TOKEN = 'CAACEdEose0cBANmpxLtqzVeLtnkatZABcA2aCKwPZCmWgZBSjQZCoTTaArsfqgJDcCVtvZCQQfPCPdhyKLguUKoETtwE1SUhPEcXcSsB9fiUZAPFnjIrHZBwS8kFmhhCp7DVxSoOMvmuokc0E3thmbyfFTp7ZBB01nEeLyNKYWBvV4SDsqUZAd62f4AomV5iqztRucxIGVsxe1QZDZD'
fg = FbGraph::Page.fetch('THSRforsale', access_token: ACCESS_TOKEN)

posts = fg.posts
post_count = 0
# LOGGER = Logger.new('xxx.log')
loop do
  posts.each do |post|
    # 不抓沒有回覆的文章
    next if post.comments.blank?
    post_count += 1
    puts "#{post.raw_attributes['message'][0..10].strip} ...".red
    puts "Post Created Time: #{post.created_time.strftime('%Y-%m-%d %H:%M:%S')}".yellow
    # puts "Comments Count: #{post.comments.count}".blue
    ParseFacebook.parase_comments(post.comments)
    ParseFacebook.get_likes(post.likes)
    puts '----------------------------------------'
  end
  
  posts = posts.next
  break if posts.blank?
end

puts '-----------------End--------------------'
puts "Post Count: #{post_count}".yellow
File.open('facebook_users.txt', 'w') { |file| file.write(ParseFacebook.get_users.join("\n")) }

