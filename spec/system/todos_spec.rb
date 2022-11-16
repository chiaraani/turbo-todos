require 'rails_helper'

RSpec.describe "Todos", type: :system do
  scenario 'Creating todo' do
    visit root_path

    fill_in(placeholder: /Add/, with: 'Do chores')
    click_on 'Create Todo'

    expect(page).to have_content('Do chores')
    expect(page).to have_button('Mark complete')
    expect(page).to have_link('Edit')
    expect(page).to have_button('Delete')
  end

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

  scenario 'Ordering todos by status' do
    todo1 = create :todo, title: 'Todo 1', status: :complete
    todo2 = create :todo, title: 'Todo 2', status: :incomplete

    visit root_path

    expect(page).to have_text(/#{todo2.title}.+#{todo1.title}/m)

    click_on 'Mark complete'

    expect(page).to have_text(/#{todo1.title}.+#{todo2.title}/m)
  end
end
