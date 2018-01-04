require_relative '../config/environment'

general_greeting
# user = login
system("clear")
user = User.find(1)
main_menu(user)
system("clear")
goodbye
