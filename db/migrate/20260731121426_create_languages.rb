class CreateLanguages < ActiveRecord::Migration[8.1]
  def change
    create_table :languages, id: :uuid do |t|
      t.string :name
      t.string :iso_code, index: { unique: true }

      t.timestamps
    end
  end
end
