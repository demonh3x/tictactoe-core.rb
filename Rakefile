task :default => ["spec:develop"]

namespace :spec do
  require './spec/rake_rspec'

  desc 'Runs unit tests'
  rspec_task(:unit) do
    exclude_tags :integration, :regression, :properties
  end

  desc 'Runs all the tests that provide fast feedback'
  rspec_task(:develop) do
    exclude_tags :regression, :properties
  end

  desc 'Runs the all the tests for continuous integration'
  rspec_task(:ci) do
    add_opts "--color -fd"
    exclude_tags :properties
  end

  desc 'Runs the property tests. Warning: this will take a long time'
  rspec_task(:properties) do
    include_tags :properties
  end
end

desc 'Measures the performace of a game with 4x4 board and computer vs computer. Outputs the results in HTML format. Warning: this will take a while'
task :profile do
  require 'ruby-prof'
  require './spec/test_run'

  RubyProf.start

  TestRun.new(4).game_winner

  result = RubyProf.stop
  RubyProf::GraphHtmlPrinter.new(result).print(STDOUT)
end

desc 'Builds the gem'
task :build do
  sh 'gem build tictactoe-core.gemspec'
end
