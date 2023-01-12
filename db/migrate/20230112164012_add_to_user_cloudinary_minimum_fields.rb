class AddToUserCloudinaryMinimumFields < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :image_public_id, :string
    add_column :users, :image_public_url, :string
  end
end
