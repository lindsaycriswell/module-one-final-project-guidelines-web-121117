class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_song_relationships
  has_many :songs, through: :playlist_song_relationships

  def list_songs
    table_data = []
    self.songs.each do |song_instance|
      table_data << {"Song ID" => song_instance.id, "Name" => song_instance.name, "Artist" => song_instance.album.artist.name}
    end
    table_data
  end
end
