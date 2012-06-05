class FirstMigration < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name

      t.timestamps
    end

    create_table :tracks do |t|
      t.string :source # youtube|soundcloud
      t.string :url
      t.string :added_by
      t.datetime :posted_on

      t.timestamps
    end
  end
end