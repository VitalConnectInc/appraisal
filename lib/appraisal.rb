# frozen_string_literal: true

# Define the namespace of this library!
module Appraisal
  # Define constants that should be available throughout the library.
  MODERN_DOUBLE_SPLAT = Gem::Version.create(RUBY_VERSION) >= Gem::Version.create('3.0')
end

require "appraisal/version"
require "appraisal/task"

Appraisal::Task.new
