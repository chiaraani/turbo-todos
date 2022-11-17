require 'rails_helper'

RSpec.describe "Todos", type: :system do
  describe '#create' do
    before { visit root_path }

    scenario 'Creating todo' do
      fill_in(placeholder: /Add/, with: 'Do chores')
      click_on 'Create Todo'

      expect(page).to have_content('Do chores')
      expect(page).to have_button('Mark complete')
      expect(page).to have_link('Edit')
      expect(page).to have_button('Delete')
    end

    scenario 'Failing to create todo with empty title' do
      fill_in(placeholder: /Add/, with: ' ')
      click_on 'Create Todo'

      expect(page).to have_content('Title can\'t be blank')
    end
  end

  describe '#update' do
    scenario 'Marking todo complete' do
      create :todo, status: :incomplete

      visit root_path 
      expect(find(':not(.complete).todo > .title')).to have_style('text-decoration' => /none/)

      click_on 'Mark complete'
      expect(find('.complete.todo > .title')).to have_style('text-decoration' => /line-through/)
    end

    scenario 'Marking todo incomplete' do
      create :todo, status: :complete

      visit root_path 
      expect(find('.complete.todo > .title')).to have_style('text-decoration' => /line-through/)

      click_on 'Mark incomplete'
      expect(find(':not(.complete).todo > .title')).to have_style('text-decoration' => /none/)
    end

    scenario 'Updating todo successfully' do
      todo = create :todo, title: 'Task'

      visit root_path
      todo_tag = find("#todo_#{todo.id}_item")

      todo_tag.click_on 'Edit'
      todo_tag.fill_in(with: 'Task 1')
      todo_tag.click_on 'Update Todo'

      expect(todo_tag.find('.title')).to have_text 'Task 1'
    end

    scenario 'Failing to update todo with empty title' do
      todo = create :todo, title: 'Task'

      visit root_path
      todo_tag = find("#todo_#{todo.id}_item")

      todo_tag.click_on 'Edit'
      todo_tag.fill_in(with: ' ')
      todo_tag.click_on 'Update Todo'

      expect(page).to have_content('Title can\'t be blank')
    end
  end

  scenario 'Ordering todos by status' do
    todo1 = create :todo, title: 'Todo 1', status: :complete
    todo2 = create :todo, title: 'Todo 2', status: :incomplete

    visit root_path
    expect(page).to have_text(/#{todo2.title}.+#{todo1.title}/m)

    click_on 'Mark complete'
    expect(page).to have_text(/#{todo1.title}.+#{todo2.title}/m)
  end
end
