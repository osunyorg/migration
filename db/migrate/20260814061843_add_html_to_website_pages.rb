class AddHtmlToWebsitePages < ActiveRecord::Migration[8.1]
  def change
    add_column :website_pages, :html, :text
  end
end
