class AddOsunyIsoCodeToWebsiteLanguages < ActiveRecord::Migration[8.1]
  def change
    add_column :website_languages, :osuny_iso_code, :string
    Website::Language.reset_column_information
    Website::Language.update_all("osuny_iso_code = iso_code")
  end
end
