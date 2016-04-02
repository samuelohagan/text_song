class UsersController < ApplicationController
  def new
  end

  	def show
  		
  			@user = current_user
  			@song = current_user.songs.build
  			@songs = @user.songs
  		
	end
end
