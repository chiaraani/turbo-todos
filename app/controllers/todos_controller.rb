# frozen_string_literal: true

# List, create, update and delete todos with Turbo Rails
class TodosController < ApplicationController
  before_action :set_todo, only: %i[edit update destroy]

  # GET /todos
  def index
    @todos = Todo.all
  end

  # GET /todos/1/edit
  def edit; end

  # POST /todos
  def create
    @todo = Todo.new(todo_params)

    respond_to { |format| create_render(format) }
  end

  # PATCH/PUT /todos/1
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        reload_todos
        format.html { redirect_to todos_url }
      else
        format.turbo_stream { render :form }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todos_url }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_todo
    @todo = Todo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def todo_params
    params.require(:todo).permit(:title, :status)
  end

  def reload_todos
    Turbo::StreamsChannel.broadcast_replace_to(
      'todos',
      target: 'todos',
      partial: 'todos/todos',
      locals: { todos: Todo.all }
    )
  end

  def create_render(format)
    if @todo.save
      @todo = Todo.new
      reload_todos
      format.html { redirect_to todos_url }
    else
      format.html { render :new, status: :unprocessable_entity }
    end
    format.turbo_stream { render :form }
  end
end
