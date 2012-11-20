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

  it "shows all users and their tracks" do
    buck = FactoryGirl.create(:buck)
    alice = FactoryGirl.create(:alice)
    white_rabbit = FactoryGirl.create(:white_rabbit)
    track = FactoryGirl.create(:track, user: buck)
    track = FactoryGirl.create(:track, user: buck)
    track = FactoryGirl.create(:track, user: alice)
    track = FactoryGirl.create(:track, user: white_rabbit)
    visit users_path
    expect(page).to have_content("Leaderboard")
    expect(page).to have_content "Buck C. - 2"
    expect(page).to have_content "Alice I. - 1"
    expect(page).to have_content "The R. - 1"
  end
end
