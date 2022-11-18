# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Todos' do
  describe '#create' do
    before { visit root_path }

    context 'when successful' do
      before do
        fill_in(placeholder: /Add/, with: 'Do chores')
        click_on 'Create Todo'
      end

      it('displays title') { expect(page).to have_content('Do chores') }

      it 'displays button "Mark complete"' do
        expect(page).to have_button('Mark complete')
      end

      it('displays link "Edit"') { expect(page).to have_link('Edit') }
      it('diplays button "Delete"') { expect(page).to have_button('Delete') }
    end

    it 'Failing to create todo with empty title' do
      fill_in(placeholder: /Add/, with: ' ')
      click_on 'Create Todo'

      expect(page).to have_content('Title can\'t be blank')
    end
  end

  describe '#update' do
    let(:status) { 'incomplete' }
    let!(:todo) { create(:todo, title: 'Task', status:) }
    let(:todo_tag) { find("#todo_#{todo.id}_item") }

    before { visit root_path }

    context 'when incomplete' do
      it 'marks todo complete' do
        click_on 'Mark complete'
        expect(find('.complete.todo > .title')).to have_style('text-decoration' => /line-through/)
      end
    end

    context 'when complete' do
      let(:status) { 'complete' }

      it 'marks todo incomplete' do
        click_on 'Mark incomplete'
        expect(find(':not(.complete).todo > .title')).to have_style('text-decoration' => /none/)
      end
    end

    it 'Updating todo successfully' do
      todo_tag.click_on 'Edit'
      todo_tag.fill_in(with: 'Task 1')
      todo_tag.click_on 'Update Todo'

      expect(todo_tag.find('.title')).to have_text 'Task 1'
    end

    it 'Failing to update todo with empty title' do
      todo_tag.click_on 'Edit'
      todo_tag.fill_in(with: ' ')
      todo_tag.click_on 'Update Todo'

      expect(page).to have_content('Title can\'t be blank')
    end

    it 'Cancelling editing todo' do
      todo_tag.click_on 'Edit'
      todo_tag.fill_in(with: 'Task 1')
      todo_tag.click_on 'Cancel'

      expect(todo_tag.find('.title')).not_to have_text 'Task 1'
    end
  end

  describe 'ordering without reloading' do
    let!(:todo1) { create(:todo, title: 'Todo 1', status: :complete) }
    let!(:todo2) { create(:todo, title: 'Todo 2', status: :incomplete) }

    before { visit root_path }

    it 'Ordering todos by status' do
      expect(page).to have_text(/#{todo2.title}.+#{todo1.title}/m)
    end

    it 'Ordering secondarily by id' do
      click_on 'Mark complete'
      expect(page).to have_text(/#{todo1.title}.+#{todo2.title}/m)
    end
  end
end
