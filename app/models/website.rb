# == Schema Information
#
# Table name: websites
#
#  id         :uuid             not null, primary key
#  name       :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Website < ApplicationRecord

  validates :name, :url, presence: true

  def to_s
    name
  end

end
