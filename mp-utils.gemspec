# frozen_string_literal: true

require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name = 'mp-utils'
  spec.version = MPUtils::VERSION
  spec.authors = ['Marcio F Paludo']
  spec.email = ['marciof.paludo@gmail.com']

  spec.summary = 'Helpers to facilitate scripts Writing'
  spec.description = 'Helpers to facilitate scripts Writing'
  spec.homepage = 'https://github.com/MarcioFPaludo/ruby-mp-utils'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.10'

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = File.join(spec.homepage, 'blob', 'main', 'CHANGELOG.md')

  spec.require_paths = ['lib']
  spec.files = Dir[File.join('lib', '**', '*')].select do |path|
    !Dir.exist?(path) && !['version.rb'].include?(File.basename(path))
  end

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
