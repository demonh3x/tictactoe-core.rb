require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

RSpec.configure  do |config|
  config.filter_run_excluding :eternal => true
  config.order = :random
end
