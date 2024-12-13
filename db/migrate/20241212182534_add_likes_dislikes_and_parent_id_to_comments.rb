class AddLikesDislikesAndParentIdToComments < ActiveRecord::Migration[6.0]
  def change
    # 댓글 좋아요 및 싫어요 수 추가
    add_column :comments, :comment_likes_count, :integer, default: 0, null: false
    add_column :comments, :comment_dislikes_count, :integer, default: 0, null: false

    # 부모 댓글을 위한 parent_id 추가
    add_column :comments, :parent_id, :integer
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
