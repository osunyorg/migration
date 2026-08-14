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
#  fk_rails_...  (default_language_id => website_languages.id)
#
class Website < ApplicationRecord

  has_many :groups, dependent: :destroy
  has_many :medias, dependent: :destroy
  has_many :pages, dependent: :destroy
  has_many :languages
  belongs_to :default_language, class_name: "Website::Language", optional: true

  validates :name, :url, presence: true
  validates :default_language_id, inclusion: { in: ->(website) { website.language_ids } }, allow_nil: true

  scope :ordered, -> {order(:name)}

  def available_strategies
    strategy_module ? strategy_module.constants : []
  end

  # Pianos Balleron -> PianosBalleron
  def to_camel
    @camelized ||= to_s.parameterize.underscore.camelize
  end

  def osuny_api_client
    return if osuny_host.blank? || osuny_api_key.blank?
    @osuny_api_client ||= OsunyApi::ApiClient.new(osuny_api_configuration)
  end

  def osuny_api_configuration
    return if osuny_host.blank? || osuny_api_key.blank?
    @osuny_api_configuration ||= begin
      config = OsunyApi::Configuration.new
      config.api_key['X-Osuny-Token'] = osuny_api_key
      config.host = osuny_host
      config.base_path = '/api/osuny/v1'
      config
    end
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
