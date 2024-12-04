# app/helpers/videos_helper.rb
module VideosHelper
  def youtube_video_id(url)
    uri = URI.parse(url)
    if uri.host == "www.youtube.com" || uri.host == "youtube.com"
      CGI.parse(uri.query)["v"]&.first
    elsif uri.host == "youtu.be"
      uri.path[1..]
    else
      nil # 유튜브 URL이 아닌 경우 nil 반환
    end
  end
end
