class Track < ActiveRecord::Base
  # t.string :source # youtube|soundcloud
  # t.string :url
  # t.string :added_by
  # t.datetime :posted_on

  scope :from_yesterday, ->{ where("created_at < ?", 1.day.ago) }
end
