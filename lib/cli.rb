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
  puts "1. View your Playlists\n2. Create a new Playlist"
  response = gets.chomp.downcase
  case response
  when "1", "view your playlists"
    user_instance.list_playlists
  when "2", "create a new playlist"

  end
end

def main_menu
  # general_greeting
  # user = login
  # system("clear")
  user = User.take(1)[0]
  user_greeting(user)
  case help
  when "1", "playlist", "playlists"
    playlists_menu(user)
  when "2", "songs", "song"
    songs_menu(user)
  when "3", "artists", "artist"
    artists_menu(user)
  when "4", "albums", "album"
    albums_menu(user)
  end
end
