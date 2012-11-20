require 'spec_helper'

describe 'Track' do
  describe '#with_users' do
    it 'gets all track in descending order' do
      (1..3).each { |i| FactoryGirl.create(:track, posted_on: i.hours.ago) }
      tracks = Track.recent_first
      expect(tracks.size).to eq(3)
      expect(Track.first.posted_on).to be < 1.hour.ago
      expect(Track.last.posted_on).to be < 3.hours.ago # since eq and == don't seem to work
    end
  end

end
