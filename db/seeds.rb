





h = RestClient.get("http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=1137a74313e9b411a812f3746dafe90f&format=json&page=1")
hash = JSON.parse(h)

binding.pry

puts "hi"
