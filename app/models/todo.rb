class Todo < ApplicationRecord
  validates :title, presence: true

  enum status: { incomplete: 0, complete: 1 }

  after_save_commit do
    broadcast_replace_to('todos', target: 'todos', partial: "todos/todos")
  end
end
