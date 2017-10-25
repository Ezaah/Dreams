class Measurement < ApplicationRecord
  belongs_to :user

  validates_presence_of :light, :sound, :temperature, :humidity, :active, :measured_at
end
