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
  puts "1. Playlists\n2. Songs\n3. Artists\n4. Albums"
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

def playlists_menu(user_instance)
  system("clear")
  submenu_welcome(user_instance, "Playlist menu")
  Formatador.display_table(user_instance.list_playlists)
  puts "Select a playlist by ID, or type 'new' to create a new playlist."
  playlist_selector(user_instance)
end

def playlist_selector(user_instance)
  response = gets.chomp.downcase
  if response == 'new'
    #create playlist method
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

def main_menu(user_instance)
  user_greeting(user_instance)
  case help
  when "1", "playlist", "playlists"
    playlists_menu(user_instance)
  when "2", "songs", "song"
    songs_menu(user_instance)
  when "3", "artists", "artist"
    artists_menu(user_instance)
  when "4", "albums", "album"
    albums_menu(user_instance)
  end
end
