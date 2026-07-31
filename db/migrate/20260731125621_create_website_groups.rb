class CreateWebsiteGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :website_groups, id: :uuid do |t|
      t.references :website, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :strategy_klass

      t.timestamps
    end
  end
end
