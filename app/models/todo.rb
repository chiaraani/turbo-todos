class Todo < ApplicationRecord
  enum status: { incomplete: 0, complete: 1 }

  validates :title, presence: true

  default_scope -> { in_order_of(:status, %w[incomplete complete]) }

  after_save_commit do
    broadcast_replace_to('todos', target: 'todos', partial: "todos/todos")
  end
end
