def general_greeting
  b = Artii::Base.new font: 'doom'
  puts b.asciify('Last.fm playlist manager!').colorize(:cyan).bold
  puts "Welcome to the Last.fm playlist manager!\n\n".colorize(:magenta)
end

def goodbye
  system("clear")
  a = Artii::Base.new font: 'doom'
  puts a.asciify('Goodbye!').colorize(:cyan).bold
end

def user_greeting(user_instance)
  puts "Hello #{user_instance.username}! What would you like to do?\n".colorize(:blue).bold
end

def submenu_welcome(user_instance, menu)
  puts "Hello #{user_instance.username}, welcome to the #{menu}! What would you like to do?\n".colorize(:blue).bold
end

def help
  puts "1. View your Playlists\n2. Search for Songs\n"
  # 3. Artists\n
  gets.chomp.downcase
end

def get_username
  puts "Please select from the following commands:\n".colorize(:blue).underline
  puts "- If you are an exisiting user, enter your username\n".colorize(:green)
  puts "- Type 'new' to create an account\n".colorize(:yellow)
  puts "- Type 'exit' at any time in the program to go back a menu\n".colorize(:red)
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
    puts "Please enter your password.".colorize(:light_blue).bold
    password(User.all.find_by(username: input))
  elsif input == "exit"
    create_new_user
  else
    puts "Invalid username. Please try again.".colorize(:red).bold
    login
  end
end

def password(user_instance)
  password_input = gets.chomp
  if password_input == user_instance.password
    user_instance
  elsif password_input == "exit"
    create_new_user
  else
    puts "Invalid password. Please try again or type 'exit' to create a new user.".colorize(:red).bold
    password(user_instance)
  end
end

def create_new_user
  puts "Please enter a new username, or type 'exit' to return to login.".colorize(:green).bold
  user_name = gets.chomp
  if User.all.find_by(username: user_name)
    puts "Username already exists.".colorize(:red).bold
    create_new_user
  elsif user_name == 'exit'
    login
  elsif user_name.split(" ").empty?
    puts "Invalid user name!"
    create_new_user
  elsif user_name.match(/\d/)
    puts "The username can't contain numbers!"
    create_new_user
  elsif user_name.match(/ /)
    puts "\nThe username can't contain spaces"
    puts " "
    create_new_user
  else
    puts "Please enter a password.".colorize(:green).bold
    password = gets.chomp
    if password == "exit"
      login
    else
      User.create(username: user_name, password: password)
    end
  end
end
#-----------------Playlist Methods---------------------------

def playlists_menu(user_instance)
  submenu_welcome(user_instance, "Playlist menu")
  Formatador.indent{Formatador.display_table(user_instance.list_playlists)}
  puts "Select a playlist by ID, or type 'new' to create a new playlist.".colorize(:blue).bold
  playlist_selector(user_instance)
end

def create_new_playlist(user_instance)
  response = gets.chomp
  user_instance.create_playlist(response, user_instance)
end

def delete_playlist(playlist_instance, user_instance)
  user_instance.delete_user_playlist(playlist_instance)
  system("clear")
  playlists_menu(user_instance)
end

def add_song_to_playlist(playlist_instance, user_instance)
  puts "Please enter song ID that you want to add.".colorize(:blue).bold
  response = gets.chomp
  if response == 'exit'
    system("clear")
    playlists_menu(user_instance)
  elsif (Song.all.select {|p| p.id == response.to_i }) == []
    puts "The song id you entered does not exist".colorize(:red).bold
    add_song_to_playlist(playlist_instance, user_instance)
  else
    playlist_instance.add_song(response)
    # playlists_menu(user_instance)
    Formatador.indent{Formatador.display_table((user_instance.playlists.select {|p| p.id == playlist_instance.id})[0].list_songs)}
    playlist_accessor(playlist_instance, user_instance)
  end
end

def remove_song_from_playlist(playlist_instance, user_instance)
  puts "Please enter song ID that you want to remove.".colorize(:red).bold
  response = gets.chomp
  if response == 'exit'
    system("clear")
    playlists_menu(user_instance)
  else
    playlist_instance.remove_song(response)
    # playlists_menu(user_instance)
    Formatador.indent{Formatador.display_table((user_instance.playlists.select {|p| p.id == playlist_instance.id})[0].list_songs)}
    playlist_accessor(playlist_instance, user_instance)
  end
end

def playlist_selector(user_instance)
  response = gets.chomp.downcase
  if response == 'new'
    puts "Please enter the name of your new Playlist".colorize(:blue).bold
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
    puts "That is not a valid playlist ID. Please try again. Or type 'new' to create a new playlist.".colorize(:red).bold
    playlist_selector(user_instance)
  end
end

def playlist_accessor(playlist_instance, user_instance)
  puts "\nPlease enter a command:\n".colorize(:blue).bold
  puts "1. Add a song\n2. Remove a song\n3. Play a song\n4. Delete playlist\n5. Return to Playlist Menu\n6. Return to Main Menu"
  response = gets.chomp.downcase
  case response
  when "1", "add", "add a song"
    add_song_to_playlist(playlist_instance, user_instance)
  when "2", "remove", "remove a song"
    remove_song_from_playlist(playlist_instance, user_instance)
  when "3", "play", "play a song"
    play_song_by_id(user_instance)
    playlist_accessor(playlist_instance, user_instance)
  when "4", "delete"
    delete_playlist(playlist_instance, user_instance)
  when "5", "playlist menu"
    system("clear")
    playlists_menu(user_instance)
  when "6", 'exit'
    system("clear")
    main_menu(user_instance)
  else
    puts "Please enter a valid command.".colorize(:red).bold
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
    puts "please enter a valid command".colorize(:red).bold
    songs_menu(user_instance)
  end
end

def search_song_by_artist(user_instance)
 puts "Please enter the name of the artist".colorize(:blue).bold
 response = gets.chomp
 if response == "exit"
   system("clear")
   songs_menu(user_instance)
 else
   artist = Artist.where("name LIKE  ?", "%#{response}%")[0]
   if !artist
     system("clear")
     puts "Artist was not found. Please search again.".colorize(:red).bold
     songs_menu(user_instance)
   else
     Formatador.display_table(artist.list_songs, ["Song ID", "Name", "Artist", "Listeners"])
   end
 end
end

def search_song_by_name(user_instance)
  puts "Please enter the name of the Song".colorize(:blue).bold
  response = gets.chomp
  if response == "exit"
    system("clear")
    songs_menu(user_instance)
  else
    array_of_songs = Song.where("name LIKE  ?", "%#{response}%")[0..9]
    if array_of_songs == []
      system("clear")
      puts "Song was not found. Please search again.".colorize(:red).bold
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
  puts "How many songs would you like to see?".colorize(:blue).bold
  length = gets.chomp
  if length.to_i <= 0 || length.to_i >= 100
    system("clear")
    puts "Please enter a number between 1 and 100.".colorize(:red).bold
    songs_menu(user_instance)
  end
  Formatador.display_table(Song.most_popular_songs(length), ["Song ID", "Name", "Artist", "Listeners"])
end

def song_sub_menu(user_instance)
  puts "\nPlease enter a command:\n".colorize(:blue).bold
  puts "1. Play song by ID\n2. Add song to playlist\n3. Return to song menu"
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
    puts "please enter a valid command".colorize(:red).bold
    song_sub_menu(user_instance)
  end
end

def play_song_by_id(user_instance)
  puts "Please enter a song ID".colorize(:blue).bold
  response = gets.chomp
  if (Song.all.select {|p| p.id == response.to_i }) != []
    Launchy.open((Song.all.select {|p| p.id == response.to_i })[0].url)
  elsif response == "exit"
    system("clear")
    main_menu(user_instance)
  else
    puts "please enter a valid song ID".colorize(:red).bold
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
    puts "Please enter a valid command.".colorize(:red).bold
    main_menu(user_instance)
  end
end
