require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { should validate_presence_of(:label) }
  it { should validate_uniqueness_of(:label) }
  it { should have_and_belong_to_many(:tasks) }
end
