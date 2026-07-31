class AddDefaultLanguageToWebsites < ActiveRecord::Migration[8.1]
  def change
    add_reference :websites, :default_language, foreign_key: { to_table: :languages }, type: :uuid
  end
end
