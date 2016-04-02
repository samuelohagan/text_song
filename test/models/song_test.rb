require 'test_helper'

class SongTest < ActiveSupport::TestCase
	test "spotifydownloaded" do
  		assert_equal "blah", Song.downloadspotify()
  	end
end
