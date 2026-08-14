require "test_helper"

# == Schema Information
#
# Table name: website_medias
#
#  id                                  :uuid             not null, primary key
#  osuny_active_storage_blob_filename  :string
#  url                                 :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  osuny_active_storage_blob_id        :string
#  osuny_active_storage_blob_signed_id :string
#  osuny_communication_media_id        :string
#  website_id                          :uuid             not null
#
# Indexes
#
#  index_website_medias_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class Website::MediaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
