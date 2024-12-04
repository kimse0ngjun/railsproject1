class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.boolean :subscription
      t.string :video_url
      t.integer :likes
      t.integer :dislike
      t.integer :video_length

      t.timestamps
    end
  end
end
