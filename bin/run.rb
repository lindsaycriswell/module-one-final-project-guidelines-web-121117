require_relative '../config/environment'

general_greeting
# user = login
system("clear")
user = User.take(1)[0]
main_menu(user)
