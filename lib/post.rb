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

end
