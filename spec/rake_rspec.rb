require 'rspec/core/rake_task'
  
class RSpecTask
  def initialize(task)
    @task = task
  end

  def add_opts(opts)
    @task.rspec_opts ||= ""
    @task.rspec_opts += " #{opts}"
  end

  def include_tag(tag)
    add_opts "--tag #{tag.to_s}"
  end

  def exclude_tag(tag)
    add_opts "--tag ~#{tag.to_s}"
  end

  def include_tags(*tags)
    tags.flatten.each {|t| include_tag t}
  end

  def exclude_tags(*tags)
    tags.flatten.each {|t| exclude_tag t}
  end

  def eval(&block)
    instance_eval &block
  end

  def method_missing(sym, *args, &block)
    @task.send sym, *args, &block
  end
end

def rspec_task(task_name, &block)
  RSpec::Core::RakeTask.new(task_name) do |task|
    RSpecTask.new(task).eval(&block)
  end
end
