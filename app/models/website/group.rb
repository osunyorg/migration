class Website::Group < ApplicationRecord
  belongs_to :website

  def to_s
    name
  end
end
