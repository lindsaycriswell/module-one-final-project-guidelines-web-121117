
class Song < ActiveRecord::Base
  belongs_to :album
  has_many :playlist_song_relationships
  has_many :playlists, through: :playlist_song_relationships


  def self.most_popular_songs(length)
    table_data = []
    Song.all.order(listeners: :desc).limit(length.to_i).each do |song_instance|
      table_data << {"Song ID" => song_instance.id, "Name" => song_instance.name, "Artist" => song_instance.album.artist.name, "Listeners" => song_instance.listeners}
    end
    table_data
  end


end
