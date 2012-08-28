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

  def first_name
    name.split(" ")[0]
  end

  def last_initial
    name.split(" ").last[0]
  end
end
