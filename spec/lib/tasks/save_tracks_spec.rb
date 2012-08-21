require 'rake'
require 'spec_helper'
require "#{Rails.root}/lib/example_feed"

describe 'rake hoc:tracks' do
  it "grabs all the feed items with youtube/soundcloud links" do
    stub(User)
    graph = Koala::Facebook::API.stub(:new, 'hello')
    graph.stub(:get_connections, "goodbye")
    
    #Rake::Task['hoc:tracks'].invoke
  end
end
