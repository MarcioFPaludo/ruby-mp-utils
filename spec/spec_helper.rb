# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  enable_coverage_for_eval
  enable_coverage :branch
  primary_coverage :branch

  minimum_coverage branch: 90, line: 90
  maximum_coverage_drop branch: 5, line: 5
  minimum_coverage_by_file branch: 85, line: 85
  
  add_filter 'spec'
  add_filter 'version.rb'
  add_filter 'mp_utils.rb'

  track_files 'lib/**/*.rb'
  
  SimpleCov.at_exit do
    SimpleCov.result.format!
  end
end

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See https://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
