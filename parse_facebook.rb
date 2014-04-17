require 'logger'
class ParseFacebook
  USERS = []
  # LOGGER = Logger.new('xxx.log')

  def self.get_likes(likes)
    post_likes = likes
    like_count = 0
    loop do
      like_count += post_likes.count
      self.cache_user(post_likes.group_by{|v| v.raw_attributes['id']}.keys)
      post_likes = post_likes.next
      break if post_likes.blank?
    end
  end

  def self.parase_comments(comments, level = 0)
    self.cache_user(comments.group_by{|v| v.raw_attributes['from']['id']}.keys)
    self.cache_user(comments.collect{|v| v.raw_attributes['from']['id']})
  end

  def self.get_users
    USERS
  end

  def self.cache_user(ids)
    # LOGGER.debug(ids.inspect)
    USERS.concat(ids).uniq
  end
end