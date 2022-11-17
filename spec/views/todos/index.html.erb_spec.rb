require 'rails_helper'

RSpec.describe "todos/index", type: :view do
  it 'renders todos' do
    todos = create_list(:todo, 5)
    assign(:todos, todos)
    
    render

    assert_select "h1", "Turbo Todos"

    assert_select "turbo-cable-stream-source"

    todos.each do |todo|
      assert_select "#todos #todo_#{todo.id}"
    end
  end
end
