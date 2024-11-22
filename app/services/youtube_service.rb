require 'httparty'

class YoutubeService
	include HTTParty
	base_uri 'https://www.googleapis.com/youtube/v3'
	
	def initialize(api_key)
		@api_key = api_key
	end
	
	# 검색어를 기반으로 동영상을 가져오는 방법
	def search_videos(query, max_results = 10)
		options = {
			query: {
				part: 'snippet',
				q: query,
				type: 'video',
				maxResults: max_results,
				key: @api_key
				}
			}
	response = self.class.get('/search', options)
	parse_response(response)
	end
	
	def fetch_video_details(video_id)
		options = {
			query: {
				part: 'snippet,statistics',
				id: video_id,
				key: @api_key
				}
			}
			response = self.class.get('/videos', options)
			parse_response(response)
		end
	
	private
			
	def parse_response(response)
		if response.succuss?
			response.parsed_response
		else
			Rails.logger.error("Youtube API 에러: #{response['error']['message']}")
			{}
		end
	end
end