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

  def delete_user_playlist(playlist_instance)
    self.playlists.delete(playlist_instance)
  end

  def create_playlist(playlist_name, user_instance)
    if playlist_name.split(" ").empty?
      system("clear")
        puts "Playlist name cannot be blank.".colorize(:red).bold
        playlists_menu(user_instance)
    else
      if (self.playlists.select {|p| p.name == playlist_name }) == []
        self.playlists << Playlist.create(name: playlist_name, user_id: self.id)
        playlists_menu(user_instance)
      elsif playlist_name == 'exit'
        playlists_menu(user_instance)
      else
        system("clear")
        puts "Playlist name already exists.".colorize(:red).bold
        playlists_menu(user_instance)
      end
    end
  end
end
