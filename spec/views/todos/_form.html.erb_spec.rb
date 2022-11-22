# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos/_form' do
  let(:form) { ['form[action=?][method=?]', path, 'post'] }

  before { render partial: 'todos/form', locals: { todo: } }

  shared_examples 'form' do
    it 'renders todo form' do
      assert_select(*form) do
        assert_select 'input[name=?][type=text]', 'todo[title]'

        assert_select 'input[type=submit]'
      end
    end
  end

  context 'when new' do
    let(:todo) { Todo.new }
    let(:path) { todos_path }

    include_examples 'form'

    it 'does NOT render cancel button' do
      assert_select(*form) do
        assert_select 'a[href=?]', todos_path, text: 'Cancel', count: 0
      end
    end
  end

  context 'when editing' do
    let!(:todo) { create(:todo) }
    let(:path) { todo_path(todo) }

    include_examples 'form'

    it 'renders cancel button' do
      assert_select(*form) do
        assert_select 'a[href=?]', todos_path, text: 'Cancel'
      end
    end
  end
end
