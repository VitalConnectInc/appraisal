# frozen_string_literal: true

require "appraisal/version"
require "appraisal/task"

module Appraisal
  MODERN_DOUBLE_SPLAT = Gem::Version.create(RUBY_VERSION) >= Gem::Version.create('3.0')
end

Appraisal::Task.new
