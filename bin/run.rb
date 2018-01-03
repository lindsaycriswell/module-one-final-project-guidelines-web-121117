require_relative '../config/environment'




def add_songs_playcount
  counter = 100

  while counter < 200

    h = RestClient.get("http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=1137a74313e9b411a812f3746dafe90f&format=json&page=#{counter}")
    hash = JSON.parse(h)

    hash["tracks"]["track"].each do |thing|
      if Song.find_by_name(thing["name"])
        Song.find_by_name(thing["name"]).update(play_count: thing["playcount"].to_i, listeners: thing["listeners"].to_i)
      end
    end
    counter += 1
  end
end

add_songs_playcount
