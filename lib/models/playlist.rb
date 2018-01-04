class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_song_relationships
  has_many :songs, through: :playlist_song_relationships

  def list_songs
    self.songs.map do |song_instance|
      {"Song ID" => song_instance.id, "Name" => song_instance.name, "Artist" => song_instance.album.artist.name}
    end
  end

  def add_song(add_song_id)
    if (playlist_song_relationships.all.select {|psr| psr.song_id == add_song_id.to_i && psr.playlist_id == self.id}) == []
      # PlaylistSongRelationship.create(playlist_id: self.id, song_id: add_song_id)
      self.songs << Song.find(add_song_id)
    else
      puts "This song is already on this playlist."
    end
  end

  def remove_song(remove_song_id)
    if (playlist_song_relationships.all.select {|psr| psr.song_id == remove_song_id.to_i && psr.playlist_id == self.id}) != []
      PlaylistSongRelationship.delete((playlist_song_relationships.all.select {|psr| psr.song_id == remove_song_id.to_i && psr.playlist_id == self.id})[0].id)
      self.songs.delete(Song.find(remove_song_id))
    else
      puts "This song is not on this playlist."
    end
  end


end
