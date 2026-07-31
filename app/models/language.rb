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
class Language < ApplicationRecord
  validates :name, :iso_code, presence: true
  validates :iso_code, uniqueness: true

  def to_s
    name
  end
end
