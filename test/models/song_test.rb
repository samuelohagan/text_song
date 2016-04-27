require 'test_helper'

class SongTest < ActiveSupport::TestCase
	test "spotifydownloaded" do
  		assert_equal "blah", Song.downloadspotify("https://play.spotify.com/user/samuelohagan/playlist/1Y308My6wMypsQjUp7eKVt")
  	end
end
