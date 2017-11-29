RSpec.describe(User, type: :model) do
  context 'check validate' do
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_length_of(:password).is_at_least(6) }
    it { should have_many(:tasks) }
  end
end