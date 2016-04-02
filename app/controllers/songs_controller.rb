class SongsController < ApplicationController
	def create
		@song = current_user.songs.build(song_params)
		@song.user_id = current_user.id
    	@song.save
    	redirect_to user_path(id: current_user)
	end

	

	private

	def song_params
		params.require(:song).permit(:query, :name)
	end

end
