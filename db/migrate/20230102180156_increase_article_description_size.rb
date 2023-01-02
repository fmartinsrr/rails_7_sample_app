class IncreaseArticleDescriptionSize < ActiveRecord::Migration[7.0]
  def up
    change_column :articles, :description, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :articles, :description, :string
  end
end
