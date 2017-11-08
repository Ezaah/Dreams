class Alert < ApplicationRecord
  belongs_to :user

  validates_presence_of :sensor, :alert_type, :active
end
