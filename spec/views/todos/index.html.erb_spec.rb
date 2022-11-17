# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos/index' do
  let(:todos) { create_list(:todo, 5) }

  before do
    assign(:todos, todos)
    render
  end

  it 'renders todos' do
    assert_select 'h1', 'Turbo Todos'
    assert_select 'turbo-cable-stream-source'

    todos.each do |todo|
      assert_select "#todos #todo_#{todo.id}"
    end
  end
end
