# frozen_string_literal: true

class Todo < ApplicationRecord
  enum status: { incomplete: 0, complete: 1 }

  validates :title, presence: true

  default_scope -> { in_order_of(:status, %w[incomplete complete]) }
end
