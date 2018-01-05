

class Artist < ActiveRecord::Base
    has_many :albums
    has_many :songs, through: :albums


    def list_songs
      table_data = []
      self.songs.each do |song_instance|
        table_data << {"Song ID" => song_instance.id, "Name" => song_instance.name, "Artist" => song_instance.album.artist.name, "Listeners" => song_instance.listeners}
      end
      table_data
    end
end
