require 'rails_helper'

RSpec.describe Alert, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:measurement) }
  it { should validate_presence_of(:light_alert) }
  it { should validate_presence_of(:sound_alert) }
  it { should validate_presence_of(:temperature_alert) }
  it { should validate_presence_of(:humidity_alert) }
  it { should validate_presence_of(:active) }
end
