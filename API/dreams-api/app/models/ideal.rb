class Ideal < ApplicationRecord
  belongs_to :user

  validates_presence_of :alert_type, :sensor, :range_min, :range_max, :active
end
