# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake'

require_relative 'lib/mp_utils'
require_relative 'lib/version'

CLEAN.include %w[pkg coverage *.gem doc .yardoc]
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: %i[spec rubocop]

namespace :version do
  %i[major minor patch].each do |part|
    desc "Bump #{part} version"
    task part do
      version = VersionManager.new(MPUtils::VERSION)
      path = File.join('lib', 'version.rb')

      case part
      when :major
        version.increment_major
      when :minor
        version.increment_minor
      when :patch
        version.increment_pathc
      end

      content = File.read(path)
      content.gsub!(/VERSION.+'#{MPUtils::VERSION}'/, "VERSION = '#{version}'")
      File.open(path, 'w') { |file| file << content }

      system("echo \"::set-output name=new_version::#{version}\"")
    end
  end
end

namespace :doc do
  desc 'Bump  version'
  task :test do
    system('yard doc')
    system('open "http://localhost:8808"')
    system('yard server')
  end
end
