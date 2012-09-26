class FeedItem

  attr_reader :user_fb_id, :posted_on, :source_site, :url, :title

  def initialize(item)
    @user_fb_id = item['from']['id']
    @posted_on = item['created_time']
    @source_site = source_site_extractor(item['link']) || 'unknown'
    @url = url_extractor(item['link'])
    @title = item['name'] || 'ID'
  end

  def source_site_extractor(link)
    match = link.match(/youtube|soundcloud|youtu\.be/).to_s
    match == 'youtu.be' ? 'youtube' : match
  end

  def url_extractor(link)
    link.match(/http:\/\/[^&|\s]*/).to_s
  end

end
