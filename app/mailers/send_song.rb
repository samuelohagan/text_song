class SendSong < ApplicationMailer

	def send_song_email(user)
    @user = current_user
    mail( :to => @user.email,
    :subject => 'Link to your songs' )
  	end


end
