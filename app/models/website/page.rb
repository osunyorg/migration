# == Schema Information
#
# Table name: website_pages
#
#  id          :uuid             not null, primary key
#  body        :text
#  crawled_at  :datetime
#  migrated_at :datetime
#  title       :string
#  url         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  group_id    :uuid
#  language_id :uuid             not null
#  parent_id   :uuid
#  website_id  :uuid             not null
#
# Indexes
#
#  index_website_pages_on_group_id     (group_id)
#  index_website_pages_on_language_id  (language_id)
#  index_website_pages_on_parent_id    (parent_id)
#  index_website_pages_on_website_id   (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (group_id => website_groups.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (parent_id => website_pages.id)
#  fk_rails_...  (website_id => websites.id)
#
class Website::Page < ApplicationRecord
  belongs_to :website
  belongs_to :language
  belongs_to :group, optional: true
  belongs_to :parent, class_name: "Website::Page", optional: true

  validates :title, :url, :language_id, presence: true
end
