require 'fb_graph'
require 'colorize'

exec('ruby get_users.rb') unless File.exists?('facebook_users.rtf')

file = File.open('facebook_users.rtf')
users = eval(file.first)

users.each do |fb_id|
  puts "ID: #{fb_id}"
end
puts "User Count: #{users.count}".yellow