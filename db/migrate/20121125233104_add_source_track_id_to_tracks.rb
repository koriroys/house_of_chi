class AddSourceTrackIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :source_track_id, :string
  end
end
