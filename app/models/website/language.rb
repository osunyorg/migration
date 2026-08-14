# == Schema Information
#
# Table name: website_languages
#
#  id             :uuid             not null, primary key
#  iso_code       :string
#  name           :string
#  osuny_iso_code :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  website_id     :uuid             not null
#
# Indexes
#
#  index_website_languages_on_iso_code    (iso_code) UNIQUE
#  index_website_languages_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class Website::Language < ApplicationRecord
  belongs_to :website
  has_many :pages

  validates :name, :iso_code, presence: true
  validates :iso_code, uniqueness: true

  scope :ordered, -> { order(:iso_code) }

  def to_s
    name
  end
end
