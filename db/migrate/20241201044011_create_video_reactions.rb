# db/migrate/20241201012345_create_video_reactions.rb
class CreateVideoReactions < ActiveRecord::Migration[6.0]
  def change
    create_table :video_reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.integer :reaction_type, null: false, default: 0 # 0: dislike, 1: like

      t.timestamps
    end

    add_index :video_reactions, [:user_id, :video_id], unique: true # 한 유저는 한 영상에 대해 하나의 반응만 가능
  end
end
