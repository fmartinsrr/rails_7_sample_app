class AddUpdateCountToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :update_count, :integer, default: 0
  end
end
