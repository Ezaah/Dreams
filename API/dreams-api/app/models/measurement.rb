class Measurement < ApplicationRecord
  belongs_to :user
  has_one :alert, dependent: :destroy
  validates_presence_of :light, :sound, :temperature, :humidity, :active
end
