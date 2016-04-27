class SongsController < ApplicationController
	def create

		
		song_spotify = Song.downloadspotify(song_params[:query], current_user.id)
		

		i = 0
		
			song_spotify.first.each do |track|

				
				@song = current_user.songs.build(query: track, name: song_spotify.last[i])

				@song.user_id = current_user.id
	    		@song.save
	    		
	    		i += 1
	    	end


		

		
    	redirect_to user_path(id: current_user)
	end

	def destroy_multiple

		if params[:commit] == 'Delete selected'
	        params[:songs].each do |songid|
				songname = Song.find_by(id: songid)
				File.delete("public/" + songname.query + ".mp3")
			end
		
	  	Song.destroy(params[:songs])

	  	respond_to do |format|
		    format.html { redirect_to user_path(id: current_user) }
		    format.json { head :no_content }
	  	end

    	elsif params[:commit] == 'Download'

        	params[:songs].each do |songid|
        		songname = Song.find_by(id: songid)
        		songpath = 'public/' + songname.query + '.mp3'
        		send_file songpath, type: 'audio/mpeg'
        		sleep(2)


        	end

    	end

		

	  	


	 end

	private



	def song_params
		params.require(:song).permit(:query, :name)
	end

end
