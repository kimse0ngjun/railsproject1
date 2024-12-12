class AddCommentIdToVideoReactions < ActiveRecord::Migration[6.0]
  def change
    add_column :video_reactions, :comment_id, :integer, null: true
	add_index :video_reactions, :comment_id 
  end
end
