require 'bundler'
require 'json'
require 'rest-client'
require 'pry'

Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'




# Application name	Super chill app
# API key	1137a74313e9b411a812f3746dafe90f
# Shared secret	b57fd233d29c98ab0a43eaa11ff8fee7
# Registered to	joeroki
