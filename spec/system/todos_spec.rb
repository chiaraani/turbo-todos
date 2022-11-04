require 'rails_helper'

RSpec.describe "Todos", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario 'Creating a todo' do
    visit root_path
    byebug

    fill_in 'todo', with: 'Do chores'

    click_on 'Create Todo'

    expect(page).to have_content('Do chores')
    expect(page).to have_button('Mark complete')
  end
end
