class RenameBody < ActiveRecord::Migration[8.1]
  def change
    remove_column :website_pages, :html
    rename_column :website_pages, :body, :html
  end
end
