class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :measurement

  validates_presence_of :light_alert, :sound_alert, :temperature_alert, :humidity_alert, :active
end
