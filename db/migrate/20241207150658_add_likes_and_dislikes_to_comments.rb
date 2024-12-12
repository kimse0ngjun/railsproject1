class AddLikesAndDislikesToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :comment_likes_count, :integer
    add_column :comments, :comment_dislikes_count, :integer
  end
end
