# == Schema Information
#
# Table name: website_groups
#
#  id              :uuid             not null, primary key
#  name            :string
#  settings        :jsonb            not null
#  strategy_klass  :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  osuny_target_id :string
#  website_id      :uuid             not null
#
# Indexes
#
#  index_website_groups_on_website_id  (website_id)
#
# Foreign Keys
#
#  fk_rails_...  (website_id => websites.id)
#
class Website::Group < ApplicationRecord
  belongs_to :website
  has_many :pages

  scope :ordered, -> {order(:name)}

  def strategy
    return if strategy_klass.blank? || strategy_class.nil?
    @strategy ||= strategy_class.new(website)
  end

  def to_s
    name
  end

  protected

  def strategy_class
    "Strategies::#{website.to_camel}::#{strategy_klass}".safe_constantize
  end

end
