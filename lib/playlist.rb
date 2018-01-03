class Playlist < ActiveRecord::Base
    belongs_to :user
    has_many :playlist_song_relationships
    has_many :songs, through: :playlist_song_relationships
end
