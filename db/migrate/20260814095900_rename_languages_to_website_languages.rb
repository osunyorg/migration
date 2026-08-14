class RenameLanguagesToWebsiteLanguages < ActiveRecord::Migration[8.1]
  def change
    rename_table :languages, :website_languages
    add_reference :website_languages, :website, foreign_key: true, type: :uuid
    Website::Language.reset_column_information
    Website::Language.update_all("website_id = (SELECT languages_websites.website_id FROM languages_websites WHERE language_id = website_languages.id LIMIT 1)")
    drop_table :languages_websites
    change_column_null :website_languages, :website_id, false
  end
end
