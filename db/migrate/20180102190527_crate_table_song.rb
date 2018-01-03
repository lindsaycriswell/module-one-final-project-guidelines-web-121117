class CrateTableSong < ActiveRecord::Migration[5.0]
  def change
    create_table :songs do |t|
      t.string :name
      t.integer :album_id
    end
  end
end
