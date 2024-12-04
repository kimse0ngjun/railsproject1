class AddLikesAndDislikesToVideos < ActiveRecord::Migration[6.0]
  def change
    add_column :videos, :likes_count, :integer
    add_column :videos, :dislikes_count, :integer
  end
end
