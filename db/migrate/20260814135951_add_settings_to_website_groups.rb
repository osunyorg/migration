class AddSettingsToWebsiteGroups < ActiveRecord::Migration[8.1]
  def change
    add_column :website_groups, :settings, :jsonb, default: {}, null: false
  end
end
