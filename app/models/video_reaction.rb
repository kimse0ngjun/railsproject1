class VideoReaction < ApplicationRecord
  belongs_to :video
  belongs_to :user

  validates :user_id, uniqueness: { scope: :video_id, message: "사용자는 동영상당 한 번만 반응 할 수 있습니다." }
  validates :reaction_type, inclusion: { in: [0, 1], message: "Reaction must be 0 (dislike) or 1 (like)" }
end
