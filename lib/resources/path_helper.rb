# frozen_string_literal: true

# Resources Path
module Resources
  def self.library_path
    __dir__
  end

  def self.custom_path
    ENV['SCRIPT_CUSTOM_RESOURCES']
  end

  def self.define(custom_path:)
    ENV['SCRIPT_CUSTOM_RESOURCES'] = custom_path
  end
end
