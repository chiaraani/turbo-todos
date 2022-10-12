require 'rails_helper'

RSpec.describe "todos/_todo", type: :view do
  it 'renders todo' do
    todo = create(:todo)
    render partial: "todos/todo", locals: { todo: }

    assert_select "li#todo_#{todo.id}_item > turbo-frame#todo_#{todo.id}", 
      text: /#{todo.title}/ do

      switch = todo.status == "complete" ? "incomplete" : "complete"
      assert_select "form[action=?]",
        todo_path(todo, todo: { status: switch }),
        text: "Mark #{switch}" do

        assert_select "input[value=patch]"
      end

      assert_select "a[href=?]", edit_todo_path(todo), "Edit"

      assert_select "form[action=?]", todo_path(todo), text: "Delete" do
        assert_select "input[value=delete]"
      end
    end
  end
end
