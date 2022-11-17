# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos/_form' do
  let(:todo) { create(:todo) }

  before { render partial: 'todos/form', locals: { todo: } }

  it 'renders the edit todo form' do
    assert_select 'form[action=?][method=?]', todo_path(todo), 'post' do
      assert_select 'input[name=?][type=text]', 'todo[title]'

      assert_select 'input[type=submit]'
      assert_select 'a[href=?]', todo_path(todo)
    end
  end
end
