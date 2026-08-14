class AddBlobAttributesToWebsiteMedias < ActiveRecord::Migration[8.1]
  def change
    add_column :website_medias, :osuny_active_storage_blob_filename, :string
    add_column :website_medias, :osuny_active_storage_blob_signed_id, :string
  end
end
