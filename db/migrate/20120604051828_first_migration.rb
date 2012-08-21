class FirstMigration < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :name

      t.timestamps
    end

    create_table :tracks do |t|
      t.string :source # youtube|soundcloud
      t.string :url
      t.integer :user_id
      t.datetime :posted_on

      t.timestamps
    end

    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :fb_token

      t.timestamps
    end
  end
end
