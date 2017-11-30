RSpec.describe Task, type: :model do
  it { should validate_presence_of(:content) }
  it { should validate_length_of(:content).is_at_least(6) }
  it { should validate_length_of(:content).is_at_most(255) }
  it { should belong_to(:user) }
  it { should have_and_belong_to_many(:tags) }
end