json.extract! website, :id, :name, :url, :created_at, :updated_at
json.url website_url(website, format: :json)
