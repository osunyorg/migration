require "test_helper"

# == Schema Information
#
# Table name: websites
#
#  id                  :uuid             not null, primary key
#  name                :string
#  osuny_api_key       :string
#  osuny_host          :string
#  url                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  default_language_id :uuid
#  osuny_website_id    :string
#
# Indexes
#
#  index_websites_on_default_language_id  (default_language_id)
#
# Foreign Keys
#
#  fk_rails_...  (default_language_id => languages.id)
#
class WebsiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
