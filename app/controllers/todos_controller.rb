# frozen_string_literal: true

class TodosController < ApplicationController
  before_action :set_todo, only: %i[show edit update destroy]

  # GET /todos or /todos.json
  def index
    @todos = Todo.all
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.turbo_stream
        reload_todos

        format.html { redirect_to Todo, notice: 'Todo was successfully created.' }
      else
        format.turbo_stream do
          render(
            turbo_stream: turbo_stream.replace(
              "#{helpers.dom_id(@todo)}_form",
              partial: 'form',
              locals: { todo: @todo }
            )
          )
        end

        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        reload_todos
        format.html { redirect_to todos_url, notice: 'Todo was successfully updated.' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("#{helpers.dom_id(@todo)}_form", partial: 'form',
                                                                                     locals: { todo: @todo })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("#{helpers.dom_id(@todo)}_item") }
      format.html { redirect_to todos_url, notice: 'Todo was successfully destroyed.' }
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
end
