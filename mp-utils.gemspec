# frozen_string_literal: true

require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name = 'mp-utils'
  spec.version = MPUtils::VERSION
  spec.authors = ['Marcio F Paludo']
  spec.email = ['marciof.paludo@gmail.com']

  spec.homepage = 'https://github.com/MarcioFPaludo/ruby-mp-utils'
  spec.required_ruby_version = '>= 2.6.10'
  spec.license = 'MIT'

  spec.summary = 'The MP-Utils library aims to facilitate the writing of daily scripts'
  spec.description = <<~DESC
    Helpers to facilitate scripts Writing.
    It can centralize messages in files and also add facilitators for the recovery and manipulation of some contents.
  DESC

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['documentation_uri'] = 'https://marciofpaludo.github.io/ruby-mp-utils'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.require_paths = ['lib']
  spec.files = Dir[File.join('lib', '**', '*')].select do |path|
    !Dir.exist?(path) && !['version.rb'].include?(File.basename(path))
  end
end
