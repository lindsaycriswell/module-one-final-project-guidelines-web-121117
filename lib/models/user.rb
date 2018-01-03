class User < ActiveRecord::Base
  has_many :playlists
  has_many :songs, through: :playlists


  def list_playlists
    result = ""
    self.playlists.each do |playlist_instance|
      result += "Playlist ID: #{playlist_instance.id}, Name: #{playlist_instance.name}\n"
    end
    puts result
  end
end
