json.extract! page, :id, :website_id, :url, :title, :language_id, :body, :crawled_at, :migrated_at, :group_id, :parent_id, :created_at, :updated_at
json.url website_page_url(page, format: :json)
