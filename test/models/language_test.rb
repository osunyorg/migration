require "test_helper"

# == Schema Information
#
# Table name: languages
#
#  id         :uuid             not null, primary key
#  iso_code   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_iso_code  (iso_code) UNIQUE
#
class LanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
