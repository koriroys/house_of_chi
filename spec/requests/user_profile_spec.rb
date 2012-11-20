require 'spec_helper'

describe "user profile" do
  describe "user.tracks" do
    it "lists all the tracks for that user" do
      buck = FactoryGirl.create(:buck)
      3.times { FactoryGirl.create(:track, user: buck) }
      buck.tracks.count.should == 3
    end
  end

  it "shows the user's tracks" do
    buck = FactoryGirl.create(:buck)
    track = FactoryGirl.create(:track, user: buck)
    visit user_tracks_path(buck)
    expect(page).to have_content("Tracks posted by Buck C.")
    expect(page).to have_content track.title
  end
end
