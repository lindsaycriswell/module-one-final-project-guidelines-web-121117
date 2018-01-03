


class Song < ActiveRecord::Base
  belongs_to :album
  has_many :playlist_song_relationships
  has_many :playlists, through: :playlist_song_relationships
end
