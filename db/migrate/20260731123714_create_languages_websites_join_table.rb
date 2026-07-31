class CreateLanguagesWebsitesJoinTable < ActiveRecord::Migration[8.1]
  def change
    create_join_table :languages, :websites, column_options: { type: :uuid } do |t|
      t.index [:website_id, :language_id]
    end
  end
end
