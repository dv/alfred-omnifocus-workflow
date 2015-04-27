require "task"

class TaskGenerator
  attr_accessor :query, :projects, :contexts

  def initialize(query)
    @query = query
    @current_task = Task.new(query)
  end

  def tasks
    matched_tasks =
      if @current_task.likely_editing?(:context)
        matching_items(contexts, current_context).map do |context|
          task = Task.new(query)
          task.context = context

          task
        end
      else
        matching_items(projects, current_project).map do |project|
          task = Task.new(query)
          task.project = project

          task
        end
      end

    # Prepend unadulterated task if not editing project either
    if matched_tasks.empty? \
      || (!@current_task.likely_editing?(:project) && !@current_task.likely_editing?(:context))
      matched_tasks.unshift(Task.new(query))
    end

    matched_tasks
  end

private

  def current_project
    @current_task.project
  end

  def current_context
    @current_task.context
  end

  def matching_items(items, value)
    if value
      item_matcher = regexp(value)

      items.select{|item| item_matcher.match(item) }
    else
      items
    end
  end

  # Turns "shop" into /.*s.*h.*o.*p/i
  def regexp(value)
    source = value.chars.inject("") do |memo, char|
      memo << ".*" + char
    end

    Regexp.new(source, true)
  end

end