require 'fb_graph'
require 'colorize'

exec('ruby get_users.rb') unless File.exists?('facebook_users.rtf')

file = File.open('facebook_users.rtf')
users = eval(file.first)

users.each do |id, name|
  puts "ID: #{id}, Name: #{name}"
end
puts "User Count: #{users.count}".yellow