module UrlExtractor
  def source_site_extractor(text)
    match = text.match(/youtube|soundcloud|youtu\.be/).to_s
    match == 'youtu.be' ? 'youtube' : match
  end

  def url_extractor(text)
    text.match(/https?:\/\/[^&|\s]*/).to_s
  end
end

class Post
  attr_reader :user_fb_id, :posted_on, :source_site, :url, :title, :comments
  include UrlExtractor

  def initialize(post)
    @user_fb_id = post['from']['id']
    @posted_on = post['created_time']
    @url = url_extractor(post['link'] || post['message'] || '')
    @source_site = source_site_extractor(url || '')
    @title = post['name'] || 'ID'
    @comments = post['comments']
  end
end

class Comment
  attr_accessor :url, :source_site, :from_id, :posted_on
  include UrlExtractor

  def initialize(comment)
    @source_site = source_site_extractor(comment['message'])
    @url = url_extractor(comment['message'])
    @from_id = comment['from']['id']
    @posted_on = comment['created_time']
  end
end

class UserCreator
  attr_reader :user_data
  def initialize(feed)
    @user_data = extract_users(feed)
  end

  def create_users
    user_data.each do |user|
      User.find_or_create(user['id'], user['name'], 'fb')
    end
  end

  private

  def extract_users(feed)
    users = extract_post_authors(feed)
    users += extract_comment_authors(feed)
    users.uniq!
  end

  def extract_post_authors(feed)
    feed.map{ |post| post['from'] }
  end

  def extract_comment_authors(feed)
    feed.select{ |post| post['comments'].present? }
        .map{ |post| post['comments']['data'] }
        .flatten
        .compact
        .map{ |comment| comment['from'] }
  end
end
