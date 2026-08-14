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

  def sync_to_osuny!
    return if osuny_communication_media_id.present?
    osuny_api = OsunyApi::CommunicationWebsiteMediaApi.new(website.osuny_api_client)
    response = osuny_api.communication_medias_post_with_http_info({
      url: url,
      return_type: 'Object'
    })
    osuny_communication_media = response[0]
    update!(
      osuny_communication_media_id: osuny_communication_media[:id],
      osuny_active_storage_blob_id: osuny_communication_media[:original_blob][:id]
    )
  end
end
