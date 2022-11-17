# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Todo do
  it { is_expected.to define_enum_for(:status) }

  it 'is ordered by status: incomplete, complete' do
    complete = create_list(:todo, 3, status: :complete)
    incomplete = create_list(:todo, 3, status: :incomplete)

    expect(described_class.all).to eq incomplete + complete
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
