class Task
  attr :task_string
  attr_accessor :project, :context

  PROJECT_REGEXP = /(^|\s)(?<project> (::|:)(\S*))/x
  CONTEXT_REGEXP = /(^|\s)(?<context> @((\S+)|(\z)))/x

  def initialize(task_string = nil)
    self.task_string = task_string || ""
  end

  def task_string=(task_string)
    @task_string = task_string.dup.strip

    if matches = PROJECT_REGEXP.match(task_string)
      @project = matches[:project].gsub(/\A:+/, "") # Strip leading colons
    end

    if matches = CONTEXT_REGEXP.match(task_string)
      @context = matches[:context].gsub(/\A@/, "") # Strip leading at-sign
    end
  end

  def likely_editing?(project_or_context)
    regexp_in_order =
      case project_or_context
      when :project
        [CONTEXT_REGEXP, PROJECT_REGEXP]
      when :context
        [PROJECT_REGEXP, CONTEXT_REGEXP]
      end

    matches = regexp_in_order.map{ |regexp| regexp.match(task_string) }

    if matches.all?
      matches[0].offset(0)[0] < matches[1].offset(0)[0]
    else
      !matches[1].nil?
    end
  end


  alias_method :to_s, :task_string

  def project=(project)
    @project = project
    @project_changed = true

    set_match(PROJECT_REGEXP, "::#{project}")
  end

  def project_changed?
    @project_changed
  end

  def context=(context)
     @context = context
     @context_changed = true

    set_match(CONTEXT_REGEXP, "@#{context}")
  end

  def context_changed?
    @context_changed
  end

private

  def set_match(regexp, value)
    terse_value = value.gsub(" ", "")

    if match = regexp.match(task_string)
      @task_string = "#{match.pre_match.strip} #{terse_value} #{match.post_match.strip}".strip
    else
      @task_string << " #{terse_value}"
    end
  end

end
