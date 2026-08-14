# == Schema Information
#
# Table name: websites
#
#  id                  :uuid             not null, primary key
#  name                :string
#  url                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  default_language_id :uuid
#
# Indexes
#
#  index_websites_on_default_language_id  (default_language_id)
#
# Foreign Keys
#
#  fk_rails_...  (default_language_id => languages.id)
#
class Website < ApplicationRecord

  has_many :groups, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_and_belongs_to_many :languages
  belongs_to :default_language, class_name: "Language", optional: true

  validates :name, :url, presence: true
  validates :default_language_id, inclusion: { in: ->(website) { website.language_ids } }, allow_nil: true

  def available_strategies
    strategy_module ? strategy_module.constants : []
  end

  # Pianos Balleron -> PianosBalleron
  def to_camel
    @camelized ||= to_s.parameterize.underscore.camelize
  end
  
  def to_s
    name
  end

  protected

  def strategy_module
    return unless Strategies.constants.include?(to_camel.to_sym)
    "Strategies::#{to_camel}".safe_constantize
  end
  
end
