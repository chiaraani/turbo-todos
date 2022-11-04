require 'rails_helper'

RSpec.describe "todos/index", type: :view do
  it 'renders todos' do
    todos = create_list(:todo, 5)
    assign(:todos, todos)
    allow(view).to receive(:render).and_call_original
    
    render

    assert_select "h1", "Turbo Todos"
    expect(view).to ( 
      have_received(:render).with("form", { todo: kind_of(Todo) })
    )

    assert_select "turbo-cable-stream-source"
    assert_select "#todos > [id^=todo]", times: 5
    expect(view).to have_received(:render).with(todos)
  end
end
