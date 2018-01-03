def greeting
  #change name
  puts "Welcome to our music database!"
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

# def create_new_user
#
# end

def main_menu
  greeting
  login

end
