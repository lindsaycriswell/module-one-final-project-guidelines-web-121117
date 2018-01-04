def general_greeting
  puts "Welcome to our Last.fm playlist manager!\n\n"
end

def goodbye
  puts "Goodbye!"
end

def user_greeting(user_instance)
  puts "Hello #{user_instance.username}! What would you like to do?"
end

def submenu_welcome(user_instance, menu)
  puts "Hello #{user_instance.username}, welcome to the #{menu}! What would you like to do?"
end

def help
  puts "1. View your Playlists\n2. Search for Songs\n"
  # 3. Artists\n
  gets.chomp.downcase
end

def get_username
  puts "Please select from the following commands:\n\n- If you are an exisiting user, enter your username\n\n- Type 'new' to create an account\n\n- Type 'exit' to exit the program"
  gets.chomp
end

def login
  input = get_username
  if input == "new"
    create_new_user
  elsif input == 'exit'
    goodbye
    exit!
  else
    authenticate_user(input)
  end
end

def authenticate_user(input)
  if User.all.find_by(username: input)
    puts "Please enter your password."
    password(User.all.find_by(username: input))
  elsif input == "exit"
    create_new_user
  else
    puts "Invalid username. Please try again or type 'exit' to create a new user."
    authenticate_user(gets.chomp)
  end
end

def password(user_instance)
  password_input = gets.chomp
  if password_input == user_instance.password
    user_instance
  elsif password_input == "exit"
    create_new_user
  else
    puts "Invalid password. Please try again or type 'exit' to create a new user."
    password(user_instance)
  end
end

def create_new_user
  puts "Please enter a new username, or type 'exit' to return to login."
  user_name = gets.chomp
  if User.all.find_by(username: user_name)
    puts "Username already exists."
    create_new_user
  elsif user_name == 'exit'
    login
  else
    puts "Please enter a password."
    password = gets.chomp
    User.create(username: user_name, password: password)
  end
end
#-----------------Playlist Methods---------------------------

def playlists_menu(user_instance)
  submenu_welcome(user_instance, "Playlist menu")
  Formatador.display_table(user_instance.list_playlists)
  puts "Select a playlist by ID, or type 'new' to create a new playlist."
  playlist_selector(user_instance)
end

def create_new_playlist(user_instance)
  response = gets.chomp
  user_instance.create_playlist(response, user_instance)
  # if (user_instance.playlists.select {|p| p.name == response }) == []
  #   Playlist.create(name: response, user_id: user_instance.id)
  #   playlists_menu(user_instance)
  # else
  #   system("clear")
  #   puts "Playlist name already exists."
  # end
end

def add_song_to_playlist(playlist_instance, user_instance)
  puts "Please enter song ID that you want to add."
  response = gets.chomp
  if response == 'exit'
    system("clear")
    playlists_menu(user_instance)
  else
    playlist_instance.add_song(response)
    # playlists_menu(user_instance)
    Formatador.display_table((user_instance.playlists.select {|p| p.id == playlist_instance.id})[0].list_songs)
    playlist_accessor(playlist_instance, user_instance)
  end
end

def remove_song_from_playlist(playlist_instance, user_instance)
  puts "Please enter song ID that you want to remove."
  response = gets.chomp
  if response == 'exit'
    system("clear")
    playlists_menu(user_instance)
  else
    playlist_instance.remove_song(response)
    # playlists_menu(user_instance)
    Formatador.display_table((user_instance.playlists.select {|p| p.id == playlist_instance.id})[0].list_songs)
    playlist_accessor(playlist_instance, user_instance)
  end
end

def playlist_selector(user_instance)
  response = gets.chomp.downcase
  if response == 'new'
    puts "Please enter the name of your new Playlist"
    create_new_playlist(user_instance)
  elsif (user_instance.playlists.select {|p| p.id == response.to_i }) != []
    system("clear")
    Formatador.display_table((user_instance.playlists.select {|p| p.id == response.to_i })[0].list_songs)
    # puts "Please enter a command:\n1. Add a song\n2. Remove a song\n3. Play a song"
    playlist_accessor(user_instance.playlists.select {|p| p.id == response.to_i }[0], user_instance)
  elsif response == 'exit'
    system("clear")
    main_menu(user_instance)
  else
    puts "That is not a valid playlist ID. Please try again. Or type 'new' to create a new playlist."
    playlist_selector(user_instance)
  end
end

def playlist_accessor(playlist_instance, user_instance)
  puts "Please enter a command:\n1. Add a song\n2. Remove a song\n3. Play a song\n4. Return to Playlist Menu\n5. Return to Main Menu"
  response = gets.chomp.downcase
  case response
  when "1", "add", "add a song"
    add_song_to_playlist(playlist_instance, user_instance)
  when "2", "remove", "remove a song"
    remove_song_from_playlist(playlist_instance, user_instance)
  when "3", "play", "play a song"
    play_song_by_id(user_instance)
    playlist_accessor(playlist_instance, user_instance)
  when "4", "playlist menu"
    system("clear")
    playlists_menu(user_instance)
  when "5", 'exit'
    system("clear")
    main_menu(user_instance)
  else
    puts "Please enter a valid command."
    playlist_accessor(playlist_instance, user_instance)
  end
end

#-----------------Song Methods---------------------------

def songs_menu(user_instance)
  submenu_welcome(user_instance, "Songs menu")
  puts "1. Find most popular Songs\n2. Search songs by Artist\n3. Search Songs by Name"
  response = gets.chomp.downcase
  case response
  when "1", "find most popular songs", "popular"
    popular_songs(user_instance)
    song_sub_menu(user_instance)
  when "2", "search songs by artist", "artist"
    search_song_by_artist(user_instance)
    song_sub_menu(user_instance)
  when "3", "search songs by name", "name"
    search_song_by_name(user_instance)
    song_sub_menu(user_instance)
  when "exit"
    system("clear")
    main_menu(user_instance)
  else
    system("clear")
    puts "please enter a valid command"
    songs_menu(user_instance)
  end
end

def search_song_by_artist(user_instance)
 puts "Please enter the name of the artist"
 response = gets.chomp
 if response == "exit"
   system("clear")
   songs_menu(user_instance)
 else
   artist = Artist.where("name LIKE  ?", "%#{response}%")[0]
   if !artist
     system("clear")
     puts "Artist was not found. Please search again."
     songs_menu(user_instance)
   else
     Formatador.display_table(artist.list_songs, ["Song ID", "Name", "Artist", "Listeners"])
   end
 end
end

def search_song_by_name(user_instance)
  puts "Please enter the name of the Song"
  response = gets.chomp
  if response == "exit"
    system("clear")
    songs_menu(user_instance)
  else
    array_of_songs = Song.where("name LIKE  ?", "%#{response}%")[0..9]
    if array_of_songs == []
      system("clear")
      puts "Song was not found. Please search again."
      songs_menu(user_instance)
    else
      Formatador.display_table(song_search_by_name_table_formatter(array_of_songs), ["Song ID", "Name", "Artist", "Listeners"])
    end
  end
end

def song_search_by_name_table_formatter(array_of_songs)
  table_data = []
  array_of_songs.each do |song_instance|
    table_data << {"Song ID" => song_instance.id, "Name" => song_instance.name, "Artist" => song_instance.album.artist.name, "Listeners" => song_instance.listeners}
  end
  table_data
end

def popular_songs(user_instance)
  puts "How many songs would you like to see?"
  length = gets.chomp
  if length.to_i <= 0 || length.to_i >= 100
    system("clear")
    puts "Please enter a number between 1 and 100."
    songs_menu(user_instance)
  end
  Formatador.display_table(Song.most_popular_songs(length), ["Song ID", "Name", "Artist", "Listeners"])
end

def song_sub_menu(user_instance)
  puts "Please enter a command:\n1. Play song by ID\n2. Add song to playlist\n3. Return to song menu"
  response = gets.chomp.downcase
  case response
  when "1", "play song by id", "play"
    play_song_by_id(user_instance)
    song_sub_menu(user_instance)
  when "2", "add song to playlist"
    # puts "Select a playlist by ID, or type 'new' to create a new playlist."
    playlists_menu(user_instance)
  when "3", "return to song menu", "menu"
    system("clear")
    songs_menu(user_instance)
  when "exit"
    system("clear")
    songs_menu(user_instance)
  else
    puts "please enter a valid command"
    song_sub_menu(user_instance)
  end
end

def play_song_by_id(user_instance)
  puts "Please enter a song ID"
  response = gets.chomp
  if (Song.all.select {|p| p.id == response.to_i }) != []
    Launchy.open((Song.all.select {|p| p.id == response.to_i })[0].url)
  elsif response == "exit"
    system("clear")
    main_menu(user_instance)
  else
    puts "please enter a valid song ID"
    play_song_by_id(user_instance)
  end
end


#-----------------Artist Methods---------------------------
# def artists_menu
#
# end



#-----------------Menu Methods---------------------------

def main_menu(user_instance)
  user_greeting(user_instance)
  case help
  when "1", "playlist", "playlists"
    system("clear")
    playlists_menu(user_instance)
  when "2", "songs", "song"
    system("clear")
    songs_menu(user_instance)
  # when "3", "artists", "artist"
  #   system("clear")
  #   artists_menu(user_instance)
  when "exit"
    system("clear")
    goodbye
    exit
  else
    system("clear")
    puts "Please enter a valid command."
    main_menu(user_instance)
  end
end
