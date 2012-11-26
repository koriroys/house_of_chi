require 'texticle/searchable'

class Track < ActiveRecord::Base
  extend Searchable(:title)

  after_save do |track|
    user = User.find(track.user_id)
    user.update_attribute(:track_count, user.tracks.count)
  end

  belongs_to :user

  attr_accessible :source, :url, :user, :posted_on, :title, :source_track_id

  # t.string :source # youtube|soundcloud
  # t.string :url
  # t.integer :user_id
  # t.datetime :posted_on

  scope :from_yesterday, ->{ where("created_at < ?", 1.day.ago) }
  scope :exists, ->(url, user_id){ where("url = ? AND user_id = ?", url, user_id) }
  scope :recent_first, ->{ order("posted_on DESC") }

  def self.already_exists?(url, user_id)
    exists(url, user_id).present?
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end
end
