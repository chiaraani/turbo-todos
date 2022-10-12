require 'rails_helper'

RSpec.describe "todos/edit", type: :view do
  it "renders the edit todo form" do
    @todo = assign(:todo, create(:todo))
    allow(view).to receive(:render).and_call_original

    render
    
    assert_select "turbo-frame[id=?]", "todo_#{@todo.id}" do
      assert_select "form"
    end

    expect(view).to have_received(:render).with("form", todo: @todo)
  end
end
