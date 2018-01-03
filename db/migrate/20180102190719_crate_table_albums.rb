class CrateTableAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :artist_id
      t.string :url
      t.integer :play_count
      t.string :api_id
    end
  end
end
