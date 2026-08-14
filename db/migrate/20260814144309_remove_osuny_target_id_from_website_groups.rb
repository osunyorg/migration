class RemoveOsunyTargetIdFromWebsiteGroups < ActiveRecord::Migration[8.1]
  def change
    remove_column :website_groups, :osuny_target_id
  end
end
