class CrateTableSong < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :album_id
      t.string :url
      t.integer :play_count
      t.integer :listeners
    end
  end
end
