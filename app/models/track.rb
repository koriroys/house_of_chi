class Track < ActiveRecord::Base
  belongs_to :user

  attr_accessible :source, :url, :user, :posted_on, :title

  # t.string :source # youtube|soundcloud
  # t.string :url
  # t.integer :user_id
  # t.datetime :posted_on

  scope :from_yesterday, ->{ where("created_at < ?", 1.day.ago) }
  scope :exists, ->(url, user_id){ where("url = ? AND user_id = ?", url, user_id) }

  def self.with_users
    includes(:user).order("posted_on DESC")
  end
end
