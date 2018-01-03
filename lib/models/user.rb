class User < ActiveRecord::Base
  has_many :playlists
  has_many :songs, through: :playlists

  def list_playlists
    table_data = []
    self.playlists.each do |playlist_instance|
      table_data << {"Playlist ID" => playlist_instance.id, "Name" => playlist_instance.name}
    end
    table_data
  end

end
