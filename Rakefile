task :default => ["spec:develop"]

namespace :spec do
  require './spec/rake_rspec'

  rspec_task(:unit) do
    exclude_tags :integration, :regression, :properties
  end

  rspec_task(:develop) do
    exclude_tags :regression, :properties
  end

  rspec_task(:ci) do
    add_opts "--color -fd"
    exclude_tags :properties
  end

  rspec_task(:properties) do
    include_tags :properties
  end
end

task :profile do
  require 'ruby-prof'
  require './spec/test_run'

  RubyProf.start

  TestRun.new(4).game_winner

  result = RubyProf.stop
  RubyProf::GraphHtmlPrinter.new(result).print(STDOUT)
end

task :build do
  sh 'gem build tictactoe-core.gemspec'
end
