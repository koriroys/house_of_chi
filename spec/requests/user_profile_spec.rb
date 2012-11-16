require 'spec_helper'

describe "user profile" do
  describe "user.tracks" do
    it "lists all the tracks for that user" do
      user = FactoryGirl.create(:user)
      3.times { FactoryGirl.create(:track, user: user) }
      user.tracks.count.should == 3
    end
  end

  it "shows the user's tracks" do
    user = FactoryGirl.create(:user)
    track = FactoryGirl.create(:track, user: user)
    visit user_tracks_path(user)
    expect(page).to have_content("Tracks posted by Buck C.")
    expect(page).to have_content track.title
  end
end
