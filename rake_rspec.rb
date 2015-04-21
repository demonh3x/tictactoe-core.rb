require 'rspec/core/rake_task'
  
class RSpecTask
  def initialize(task)
    @task = task
  end

  def include_tags(*tags)
    tags = tags.flatten
    @task.rspec_opts ||= ""
    @task.rspec_opts += tags.map{|tag| "--tag #{tag.to_s}"}.join(" ")
  end

  def exclude_tags(*tags)
    tags = tags.flatten
    @task.rspec_opts ||= ""
    @task.rspec_opts += tags.map{|tag| "--tag ~#{tag.to_s}"}.join(" ")
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
