require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { should define_enum_for(:status) }

  it 'is ordered by status: incomplete, complete' do
    complete = create_list :todo, 3, status: :complete
    incomplete = create_list :todo, 3, status: :incomplete

    expect(described_class.all).to eq incomplete + complete
  end
  
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end
end
