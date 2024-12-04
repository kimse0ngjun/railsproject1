class AddCategoryIdToMains < ActiveRecord::Migration[6.0]
  def change
    add_column :mains, :category_id, :integer
  end
end
