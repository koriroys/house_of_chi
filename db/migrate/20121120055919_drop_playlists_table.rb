class DropPlaylistsTable < ActiveRecord::Migration
  def up
    drop_table :playlists
  end

  def down
    create_table :playlists do |t|
      t.string :name

      t.timestamps
    end
  end
end
