require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'spec_helpers_qt'

RSpec.configure  do |config|
  config.order = :random
  config.include Qt::SpecHelpers
end
