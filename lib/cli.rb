def general_greeting
  #change name
  puts "Welcome to our music database!"
end

def user_greeting(user_instance)
  puts "Hello #{user_instance.username}! What would you like to do?"
end

def submenu_welcome(user_instance, menu)
  puts "Hello #{user_instance.username}, welcome to the #{menu}! What would you like to do?"
end

def help
  puts "1. Playlists\n2. Songs\n3. Artists\n"
  gets.chomp.downcase
end

def get_username
  puts "If you are an exisiting user, insert your username. Or type 'new' to create an account."
  gets.chomp
end

def login
  input = get_username
  if input == "new"
    create_new_user
  else
    authenticate_user(input)
  end
end

def authenticate_user(input)
  if User.all.find_by(username: input)
    puts "Please enter your password"
    password(User.all.find_by(username: input))
  elsif input == "exit"
    create_new_user
  else
    puts "Invalid username. Please try again or type 'exit' to create a new user"
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
    puts "Invalid password. Please try again or type 'exit' to create a new user"
    password(user_instance)
  end
end

def create_new_user
  puts "Please enter a username, or type 'exit' to return to login."
  user_name = gets.chomp
  if User.all.find_by(username: user_name)
    puts "Username already exists."
    create_new_user
  elsif user_name == 'exit'
    login
  else
    puts "Please enter a password"
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

def create_playlist(user_instance)
  response = gets.chomp
  if (user_instance.playlists.select {|p| p.name == response }) == []
    playlist_accessor(Playlist.create(name: response, user_id: user_instance.id))

  else
    system("clear")
    puts "Playlist name already exists."
    playlists_menu(user_instance)
  end
end

def playlist_selector(user_instance)
  response = gets.chomp.downcase
  if response == 'new'
    puts "Please enter the name of your new Playlist"
    create_playlist(user_instance)
  elsif (user_instance.playlists.select {|p| p.id == response.to_i }) != []
    system("clear")
    Formatador.display_table((user_instance.playlists.select {|p| p.id == response.to_i })[0].list_songs)
    puts "Please enter a command:\n1. Add a song\n2. Remove a song\n3. Play a song"
    playlist_accessor(user_instance.playlists.select {|p| p.id == response.to_i }[0], user_instance)
  else
    puts "That is not a valid playlist ID. Please try again. Or type 'new' to create a new playlist."
    playlist_selector(user_instance)
  end
end

def playlist_accessor(playlist_instance, user_instance)

  response = gets.chomp.downcase
  case response
  when "1", "add", "add a song"
    #add song method
  when "2", "remove", "remove a song"
    #remove song method
  when "3", "play", "play a song"
    #play song method
  when 'exit'
    system("clear")
    main_menu(user_instance)
  else
    puts "Please enter a valid command."
    playlist_accessor(playlist_instance)
  end
  binding.pry
end

#-----------------Song Methods---------------------------

def songs_menu(user_instance)
  submenu_welcome(user_instance, "Songs menu")
  puts "1. Find most popular songs\n2. Search songs by Artist\n3. Search songs by name"
  response = gets.chomp.downcase
  case response
  when "1", "find most popular songs", "popular"
    popular_songs(user_instance)
    song_sub_menu(user_instance)
  when "2", "search songs by artist", "artist"
    search_song_by_artist(user_instance)
    song_sub_menu(user_instance)
  when "3", "search songs by name", "name"
    # search_song_by_name(user_instance)
    song_sub_menu(user_instance)
  else
    puts "please enter a valid command"
    songs_menu(user_instance)
  end
end

def search_song_by_artist(user_instance)
 puts "Please enter the name of the artist"
 response = gets.chomp
 
end

# def search_song_by_name(user_instance)
#
# end

def popular_songs(user_instance)
  puts "How many songs would you like to see?"
  length = gets.chomp
  Formatador.display_table(Song.most_popular_songs(length), ["Song ID", "Name", "Artist", "Listeners"])
end

def song_sub_menu(user_instance)
  puts "Please enter a command:\n 1. Play song by ID\n2. Add song to playlist\n3. return to song menu"
  response = gets.chomp.downcase
  case response
  when "1", "play song by id", "play"
    play_song_by_id(user_instance)
    song_sub_menu(user_instance)
  when "2", "add song to playlist"
    puts "Select a playlist by ID, or type 'new' to create a new playlist."
    playlist_selector(user_instance)
  when "3", "return to song menu", "menu"
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
  else
    puts "please enter a valid song ID"
    play_song_by_id(user_instance)
  end
end

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
  when "3", "artists", "artist"
    system("clear")
    artists_menu(user_instance)
  end
end
