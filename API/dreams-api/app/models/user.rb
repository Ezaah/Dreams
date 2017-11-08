class User < ApplicationRecord
  has_many :measurements, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :ideals, dependent: :destroy

  validates_presence_of :name, :email, :password_digest, :mode, :artefact, :active
  has_secure_password
end
