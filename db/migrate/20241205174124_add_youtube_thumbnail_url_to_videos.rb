class AddYoutubeThumbnailUrlToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :youtube_thumbnail_url, :string
  end
end
