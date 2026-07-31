class CreateWebsitePages < ActiveRecord::Migration[8.1]
  def change
    create_table :website_pages, id: :uuid do |t|
      t.references :website, null: false, foreign_key: true, type: :uuid
      t.string :url
      t.string :title
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.text :body
      t.datetime :crawled_at
      t.datetime :migrated_at
      t.references :group, foreign_key: { to_table: :website_groups }, type: :uuid
      t.references :parent, foreign_key: { to_table: :website_pages }, type: :uuid

      t.timestamps
    end
  end
end
