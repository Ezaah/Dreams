require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:measurements).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:mode) }
  it { should validate_presence_of(:artefact) }
  it { should validate_presence_of(:active) }
end
