class Todo < ApplicationRecord
  enum status: { incomplete: 0, complete: 1 }

  validates :title, presence: true

  after_save_commit do
    broadcast_replace_to('todos', target: 'todos', partial: "todos/todos")
  end
end
