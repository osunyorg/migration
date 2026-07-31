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
  has_and_belongs_to_many :websites
  has_many  :websites_as_default_language,
            class_name: "Website",
            foreign_key: :default_language_id,
            dependent: :nullify

  validates :name, :iso_code, presence: true
  validates :iso_code, uniqueness: true

  def to_s
    name
  end
end
