class AddOsunyApiToWebsite < ActiveRecord::Migration[8.1]
  def change
    add_column :websites, :osuny_website_id, :string
    add_column :websites, :osuny_host, :string
    add_column :websites, :osuny_api_key, :string
  end
end
