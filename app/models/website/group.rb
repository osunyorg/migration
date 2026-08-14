# == Schema Information
#
# Table name: website_groups
#
#  id             :uuid             not null, primary key
#  name           :string
#  strategy_klass :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  website_id     :uuid             not null
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

  def migrate!
    strategy.migrate_group!(self)
  end

  def strategy
    return if strategy_klass.blank?
    @strategy ||= "Strategies::#{website.to_camel}::#{strategy_klass}".safe_constantize.new
  end

  def to_s
    name
  end

end
