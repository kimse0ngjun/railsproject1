class Comment < ApplicationRecord
  belongs_to :video
  belongs_to :user
  
  # 대댓글을 위한 자기 참조 관계 설정
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy

  # 좋아요 처리
  def like!
    if comment_likes_count == 1
      update(comment_likes_count: 0)  # 좋아요 취소
    else
      # 싫어요가 눌려 있으면 싫어요 취소하고 좋아요 추가
      update(comment_dislikes_count: 0) if comment_dislikes_count == 1
      update(comment_likes_count: 1)  # 좋아요 추가
    end
  end

  # 싫어요 처리
  def dislike!
    if comment_dislikes_count == 1
      update(comment_dislikes_count: 0)  # 싫어요 취소
    else
      # 좋아요가 눌려 있으면 좋아요 취소하고 싫어요 추가
      update(comment_likes_count: 0) if comment_likes_count == 1
      update(comment_dislikes_count: 1)  # 싫어요 추가
    end
  end

  # 댓글 삭제 처리
  def destroy_with_reactions
    # 댓글에 반영된 좋아요와 싫어요를 취소
    update(comment_likes_count: 0) if comment_likes_count == 1
    update(comment_dislikes_count: 0) if comment_dislikes_count == 1

    # 댓글 삭제
    destroy
  end
end
