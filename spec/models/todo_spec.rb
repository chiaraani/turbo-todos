require 'rails_helper'

RSpec.describe Todo, type: :model do
  it { should define_enum_for(:status) }
  
  describe 'validations' do
    it { should validate_presence_of(:title) }
  end
end
