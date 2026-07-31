class CreateWebsites < ActiveRecord::Migration[8.1]
  def change
    create_table :websites, id: :uuid do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
