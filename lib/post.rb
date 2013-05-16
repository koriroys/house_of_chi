class Post

  attr_reader :user_fb_id, :posted_on, :source_site, :url, :title, :comments

  def initialize(post)
    @user_fb_id = post['from']['id']
    @posted_on = post['created_time']
    if post['link']
      @source_site = source_site_extractor(post['link'])
      @url = url_extractor(post['link'])
    else
      @source_site = ''
      @url = ''
    end
    @title = post['name'] || 'ID'
    @comments = post['comments']
  end

  def source_site_extractor(link)
    match = link.match(/youtube|soundcloud|youtu\.be/).to_s
    match == 'youtu.be' ? 'youtube' : match
  end

  def url_extractor(link)
    link.match(/http:\/\/[^&|\s]*/).to_s
  end

end

class Comment
  attr_accessor :url, :source_site, :from_id, :posted_on

  def initialize(comment)
    @source_site = source_site_extractor(comment['message'])
    @url = url_extractor(comment['message'])
    @from_id = comment['from']['id']
    @posted_on = comment['created_time']
  end

  def source_site_extractor(message)
    match = message.match(/youtube|soundcloud|youtu\.be/).to_s
    match == 'youtu.be' ? 'youtube' : match
  end

  def url_extractor(link)
    link.match(/http:\/\/[^&|\s]*/).to_s
  end
end
