class AddCategoryToTtsItem < ActiveRecord::Migration[6.0]
  def change
    add_column :tts_items, :category, :string
  end
end
