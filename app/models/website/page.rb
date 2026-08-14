# == Schema Information
#
# Table name: website_pages
#
#  id          :uuid             not null, primary key
#  body        :text
#  crawled_at  :datetime
#  html        :text
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
  has_many :children, class_name: "Website::Page", foreign_key: :parent_id

  validates :title, :url, :language_id, presence: true

  after_commit :set_group_to_children, if: [:root?, :saved_change_to_group_id?]

  scope :root, -> { where(parent_id: nil) }
  scope :search, -> (query) { where("url ILIKE ?", "%#{sanitize_sql_like(query)}%") }
  scope :ordered_by_url, -> { order(:url) }

  def migrate!
    strategy.migrate_page!(self)
  end

  def migration_identifier
    id
  end

  def strategy
    return unless group
    @strategy ||= group.strategy
  end

  def root?
    !parent_id
  end

  def to_s
    url
  end

  protected

  def set_group_to_children
    children.update(group_id: group_id)
  end
end
