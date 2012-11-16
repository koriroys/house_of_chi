class User < ActiveRecord::Base
  has_many :tracks

  attr_accessible :name, :uid, :provider

  validates :name, :uid, :provider, presence: true

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.name = auth['info']['name']
    end
  end

  def self.find_or_create(uid, name, provider)
    find_by_uid(uid) || User.create(name: name, uid: uid, provider: provider)
  end

  def self.leaders
    order('track_count desc').take(5)
  end

  def full_name
    split_name = name.split(" ")
    "#{split_name[0]} #{split_name.last[0]}."
  end
end
