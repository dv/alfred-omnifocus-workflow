require 'appscript'

class Omnifocus

  def activate_if_not_running!
    unless app.is_running?
      app.activate
    end
  end

  def projects(without_completed: true)
    projects = doc.flattened_projects

    if without_completed
      projects = projects[whose.completed.eq(false)]
    end

    projects.name.get.map{ |name| name.force_encoding("UTF-8") }
  end

  def contexts
    doc.flattened_contexts.name.get.map{ |name| name.force_encoding("UTF-8") }
  end

  def create_task(task_string)
    app.parse_tasks_into(doc, with_transport_text: task_string)
  end

private

  def app
    Appscript.app("OmniFocus")
  end

  def whose
    Appscript.its
  end

  def doc
    app.default_document
  end

end
