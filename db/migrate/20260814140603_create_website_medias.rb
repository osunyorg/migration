class CreateWebsiteMedias < ActiveRecord::Migration[8.1]
  def change
    create_table :website_medias, id: :uuid do |t|
      t.references :website, null: false, foreign_key: true, type: :uuid
      t.string :url
      t.string :osuny_communication_media_id
      t.string :osuny_active_storage_blob_id

      t.timestamps
    end
  end
end
