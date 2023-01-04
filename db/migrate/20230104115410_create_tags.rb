class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.string :name
      t.timestamps
    end
    create_table :article_tags do |t|
      t.integer :article_id
      t.integer :tag_id
      t.timestamps
    end
  end
end
