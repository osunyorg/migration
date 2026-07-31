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

  def to_s
    name
  end
end
