# frozen_string_literal: true

require 'rake/clean'

CLEAN.include %w[pkg coverage *.gem]

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]

require_relative 'lib/version'
require 'rake'

namespace :version do
  %i[major minor patch].each do |part|
    desc "Bump #{part} version"
    task part do
      current_version = MPUtils::VERSION.split('.').map(&:to_i)
      new_version = case part
                    when :major
                      [current_version[0] + 1, 0, 0]
                    when :minor
                      [current_version[0], current_version[1] + 1, 0]
                    when :patch
                      current_version[0..1] + [current_version[2] + 1]
                    end.join('.')

      path = File.join('lib', 'version.rb')
      content = File.read(path)
      puts content
      content.gsub!(/VERSION.+'\d+\.\d+\.\d+'/, "VERSION = '#{new_version}'")
      puts content
      File.open(path, 'w') { |file| file << content }

      puts "Version bumped to #{new_version}"
    end
  end
end
