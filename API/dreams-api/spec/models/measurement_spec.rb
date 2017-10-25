require 'rails_helper'

RSpec.describe Measurement, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:light) }
  it { should validate_presence_of(:sound) }
  it { should validate_presence_of(:temperature) }
  it { should validate_presence_of(:humidity) }
  it { should validate_presence_of(:active) }
  it { should validate_presence_of(:measured_at) }
end
