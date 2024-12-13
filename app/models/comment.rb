class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :video
  has_many :likes, dependent: :destroy
  has_many :dislikes, dependent: :destroy
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_id', dependent: :destroy
  belongs_to :parent, class_name: 'Comment', optional: true

  # 좋아요 처리
  def like!
    if self.comment_likes_count.nil? || self.comment_likes_count == 0
      # 좋아요를 눌렀을 때, 좋아요 카운트 증가
      self.update(comment_likes_count: 1)
      # 싫어요 취소
      self.update(comment_dislikes_count: 0) if self.comment_dislikes_count.nil? || self.comment_dislikes_count > 0
    else
      # 좋아요를 취소했을 때, 좋아요 카운트 감소
      self.update(comment_likes_count: 0)
    end
  end

  # 싫어요 처리
  def dislike!
    if self.comment_dislikes_count.nil? || self.comment_dislikes_count == 0
      # 싫어요를 눌렀을 때, 싫어요 카운트 증가
      self.update(comment_dislikes_count: 1)
      # 좋아요 취소
      self.update(comment_likes_count: 0) if self.comment_likes_count.nil? || self.comment_likes_count > 0
    else
      # 싫어요를 취소했을 때, 싫어요 카운트 감소
      self.update(comment_dislikes_count: 0)
    end
  end

  # 댓글 삭제 시 반응도 함께 삭제
  def destroy_with_reactions
    # 반응들(좋아요, 싫어요) 삭제
    begin
      ActiveRecord::Base.transaction do
        # 좋아요, 싫어요를 삭제
        self.likes.destroy_all
        self.dislikes.destroy_all
        # 댓글 삭제
        self.destroy!
      end
      return true
    rescue => e
      Rails.logger.error "댓글 삭제 중 오류 발생: #{e.message}"
      return false
    end
  end
end
