class AddOsunyTargetIdToWebsiteGroups < ActiveRecord::Migration[8.1]
  def change
    add_column :website_groups, :osuny_target_id, :string
  end
end
