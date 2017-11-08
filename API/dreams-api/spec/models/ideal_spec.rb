require 'rails_helper'

RSpec.describe Ideal, type: :model do
  it { should belong_to(:user) }
  it { should validate_presence_of(:alert_type) }
  it { should validate_presence_of(:sensor) }
  it { should validate_presence_of(:range_min) }
  it { should validate_presence_of(:range_max) }
  it { should validate_presence_of(:active) }
end
