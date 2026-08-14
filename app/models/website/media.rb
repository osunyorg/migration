# == Schema Information
#
# Table name: website_medias
#
#  id                           :uuid             not null, primary key
#  url                          :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  osuny_active_storage_blob_id :string
#  osuny_communication_media_id :string
#  website_id                   :uuid             not null
#
# Indexes
#
#  index_website_medias_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class Website::Media < ApplicationRecord
  belongs_to :website

  validates :url, presence: true, uniqueness: { scope: :website_id }

  scope :ordered_by_url, -> { order(:url) }

  def to_s
    url
  end
end
