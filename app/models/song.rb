class Song < ActiveRecord::Base
	require 'unirest'
	require 'rubygems'
	require 'streamio-ffmpeg'
	require "resolv-replace.rb"	
  require 'fileutils'
  belongs_to :user

  


  def self.downloadvideo(query, song_id, user_id)
  		response = Unirest.get "https://www.googleapis.com/youtube/v3/search", 
                        headers:{ "Accept" => "application/json" }, 
                        parameters:{ :part => "snippet", :q => query, :key => "AIzaSyDJtrBnGjEo1XvaqlIuYUG4d1MWzMGYikQ"}
         videoid = response.body["items"][0]["id"]["videoId"]

                       

         name = 'song' + song_id.to_s + 'user' + user_id.to_s + '.opus'
  		options = {
 			output: name,
  			format: :bestaudio
  			

			}

  		YoutubeDL.download "https://www.youtube.com/watch?v=" + videoid , options 
 
  		movie = FFMPEG::Movie.new(name)
  		 movie.audio_codec
  		  transcoded_movie = movie.transcode('song' + song_id.to_s + 'user' + user_id.to_s + '.wav')
        File.delete(name)

  		
  	end


    

    def self.downloadspotify(spotify_url, userid)

      FileUtils.mkpath('/home/samuelohagan/Desktop//RailsApps/text_song/public/usernumber' + userid.to_s)
        
        if !(((spotify_url.include? "https://play.spotify.com/user/") or (spotify_url.include? "https://open.spotify.com/user/"))  and (spotify_url.include? "/playlist"))
          return "error"
        end

        spotify_url.sub!("https://play.spotify.com/user/", "https://api.spotify.com/v1/users/")
        spotify_url.sub!("https://open.spotify.com/user/", "https://api.spotify.com/v1/users/")
        spotify_url.sub!("/playlist/", "/playlists/")
        spotify_url += "/tracks"
        
      

        spotify_token = Unirest.post "https://accounts.spotify.com/api/token",
         headers:{ "Accept" => "application/json", "Authorization" => "Basic MzU0YTAzOGFjNjYyNDkyOWI0ZmZiYjk3YThkZTVkODE6OTIzZTk5YTFlNDQ1NDk1MDljNDQ2MmE4ZjM0YTA0ZWE=" }, 
                        parameters:{ :grant_type => "client_credentials" }
        access_token = spotify_token.body["access_token"]


        spotifyunparsedresponse = Unirest.get spotify_url,
         headers:{ "Accept" => "application/json", "Authorization" => "Bearer" + " " + access_token } 
        amountspotify = spotifyunparsedresponse.body["total"]
        spotify_response_track = Array.new()
        spotify_response_artist = Array.new()

        if spotifyunparsedresponse.body.to_s.include? "{\"error\"=>{\"status"
           return "error"
        end
        
        

        amountspotify.times do |i|
          spotify_response_track.push(spotifyunparsedresponse.body["items"][i]["track"]["name"])
          spotify_response_artist.push(spotifyunparsedresponse.body["items"][i]["track"]["artists"][0]["name"])


          response = Unirest.get "https://www.googleapis.com/youtube/v3/search", 
                        headers:{ "Accept" => "application/json" }, 
                        parameters:{ :part => "snippet", :q => spotify_response_artist[i] + " " + spotify_response_track[i], :key => "AIzaSyDJtrBnGjEo1XvaqlIuYUG4d1MWzMGYikQ"}
          videoid = response.body["items"][0]["id"]["videoId"]

                       

         name = 'public/' + spotify_response_track[i] + '.opus'
          options = {
          output: name,
            format: :bestaudio
            

          }

          YoutubeDL.download "https://www.youtube.com/watch?v=" + videoid , options 
     
          movie = FFMPEG::Movie.new(name)
          
          transcoded_movie = movie.transcode('public/' + spotify_response_track[i] + '.mp3')
          File.delete(name)
        end
        allspotify = [spotify_response_track, spotify_response_artist]



        

            
    end



end
