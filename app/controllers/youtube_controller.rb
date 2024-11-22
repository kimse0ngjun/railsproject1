class YoutubeController < ApplicationController
	def search
		youtube_service = YoutubeService.new([ENV['YOUTUBE_API_KEY']])
		@video = youtube_service.search_videos(params[:query], 10)
	end
end