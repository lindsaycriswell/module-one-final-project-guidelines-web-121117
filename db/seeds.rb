

def add_artists
  counter = 1
  artist_hash = Hash.new

  while counter < 11

    h = RestClient.get("http://ws.audioscrobbler.com/2.0/?method=chart.gettoptracks&api_key=1137a74313e9b411a812f3746dafe90f&format=json&page=#{counter}")
    hash = JSON.parse(h)

    hash["tracks"]["track"].each do |thing|
      # artist_name_array << thing["artist"]["name"]
      # artist_id_array << thing["artist"]["mbid"]
      artist_hash[thing["artist"]["name"]] = thing["artist"]["mbid"]
    end
    counter += 1
  end


  artist_hash.each do |name,id|
    if id != ""
    Artist.create(name: name,api_id: id)
    end
  end
end


def add_albums
  Artist.all.each do |artist_object|

    h = RestClient.get("http://ws.audioscrobbler.com/2.0/?method=artist.gettopalbums&mbid=#{artist_object.api_id}&api_key=1137a74313e9b411a812f3746dafe90f&format=json")
    hash = JSON.parse(h)


    count = 0

    3.times do
      if hash["topalbums"]["album"][count]["mbid"] != nil
      Album.create(name: hash["topalbums"]["album"][count]["name"], artist_id: (artist_object.id), api_id: hash["topalbums"]["album"][count]["mbid"], url: hash["topalbums"]["album"][count]["url"],play_count: hash["topalbums"]["album"][count]["playcount"])
      end
      count +=1
    end
  end
end

def add_songs
  albums = Album.all.map { |album_instance| album_instance.api_id }
  albums.each do |album_api_id|
    h = RestClient.get("http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=1137a74313e9b411a812f3746dafe90f&mbid=#{album_api_id}&format=json")
    hash = JSON.parse(h)

    hash["album"]["tracks"]["track"].each do |track_instance|
      if !(Song.find_by_name(track_instance["name"]))
        Song.create(name: (track_instance["name"]),album_id: (Album.where(api_id: album_api_id)[0].id),url: track_instance["url"])
      end
    end
  end
end


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



add_artists
add_albums
add_songs
add_songs_playcount
