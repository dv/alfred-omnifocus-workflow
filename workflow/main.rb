#!/usr/bin/env ruby
# encoding: utf-8
project_dir = File.dirname(__FILE__)
$:.unshift project_dir
$:.unshift File.join(project_dir, "app")

require 'rubygems'
require 'bundle/bundler/setup'
require 'alfred'
require 'omnifocus'
require 'task'
require 'task_generator'

Alfred.with_friendly_error do |alfred|
  fb = alfred.feedback
  query = ARGV.join(" ")

  omnifocus = Omnifocus.new
  omnifocus.activate_if_not_running!

  task_generator = TaskGenerator.new(query)
  task_generator.projects = omnifocus.projects
  task_generator.contexts = omnifocus.contexts

  tasks = task_generator.tasks
  tasks.push(tasks.shift)

  tasks.each do |task|
    command = task.to_s

    task_attributes = {
      subtitle: command,
      autocomplete: command + " ",
      arg: command
    }

    if task.context_changed?
      task_attributes[:title] = "Create task with context @#{task.context}"

    elsif task.project_changed?
      task_attributes[:title] = "Create task with project #{task.project}"

    else
      task_attributes[:title] = "Create Task"
      task_attributes.delete(:autocomplete)
    end

    fb.add_item(task_attributes)
  end

  puts fb.to_xml
end



