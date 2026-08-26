class ChangeUniqueIndexInWebsiteLanguages < ActiveRecord::Migration[8.1]
  def change
    remove_index :website_languages, :iso_code, unique: true
    add_index :website_languages, [:website_id, :iso_code], unique: true
  end
end
