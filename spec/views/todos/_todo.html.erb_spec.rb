# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'todos/_todo' do
  let(:todo) { create(:todo) }
  let(:turbo_frame) { "#todo_#{todo.id}_item > turbo-frame#todo_#{todo.id}" }

  before { render partial: 'todos/todo', locals: { todo: } }

  it 'renders title of todo' do
    assert_select turbo_frame, text: /#{todo.title}/
  end

  shared_examples 'Mark' do |status|
    let(:todo) { create(:todo, status:) }
    opposite = status == 'complete' ? 'incomplete' : 'complete'
    let(:form) { "form[action='#{todo_path(todo, todo: { status: opposite })}']" }

    it "renders button 'Mark #{opposite}" do
      assert_select turbo_frame do
        assert_select form do
          assert_select 'input[value=patch]'
          assert_select 'button', text: "Mark #{opposite}"
        end
      end
    end
  end

  context('when incomplete') { include_examples 'Mark', 'incomplete' }

  context('when complete') { include_examples 'Mark', 'complete' }

  it 'renders button "Edit"' do
    assert_select "#{turbo_frame} a[href=?]", edit_todo_path(todo), 'Edit'
  end

  it 'renders button "Delete"' do
    assert_select "#{turbo_frame} form[action=?]", todo_path(todo) do
      assert_select 'input[value=delete]'
      assert_select 'button', text: 'Delete'
    end
  end
end
