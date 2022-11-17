# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos/edit' do
  let!(:todo) { assign(:todo, create(:todo)) }

  before do
    allow(view).to receive(:render).and_call_original
    render
  end

  it 'renders the edit todo form' do
    assert_select 'turbo-frame[id=?]', "todo_#{todo.id}" do
      assert_select 'form'
    end

    expect(view).to have_received(:render).with('form', todo:)
  end
end
