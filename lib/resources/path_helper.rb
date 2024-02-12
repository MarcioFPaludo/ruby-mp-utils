# frozen_string_literal: true

# The Resources module manages and provides access to file system paths used by a script or application.
# It facilitates the definition and retrieval of a default library path, alongside a customizable path
# that can be set at runtime either programmatically using the {define} method or through the environment
# variable "SCRIPT_CUSTOM_RESOURCES". This flexibility allows applications to dynamically access resources
# stored in various locations, depending on execution environment or user-defined settings.
module Resources
  # Retrieves the path to the directory containing this module, which serves as the default library path.
  #
  # @return [String] the directory path of this module, used as the default library path.
  def self.library_path
    __dir__
  end

  # Returns the custom path for resources as defined by the user. This path can be set at runtime
  # through the use of the environment variable "SCRIPT_CUSTOM_RESOURCES" or programmatically via the
  # {define} method. This method allows for easy retrieval of the custom path, facilitating flexible
  # resource management.
  #
  # @return [String, nil] the custom path as defined by the environment variable, or nil if it hasn't been set.
  def self.custom_path
    ENV['SCRIPT_CUSTOM_RESOURCES']
  end

  # Provides a means to programmatically define a custom resources path at runtime. This method updates
  # the "SCRIPT_CUSTOM_RESOURCES" environment variable to store the custom path, making it retrievable
  # through the {custom_path} method. This allows for dynamic setting of resource paths based on runtime
  # conditions or user preferences.
  #
  # @param custom_path [String] the custom path to be set for resource access.
  # @return [void]
  def self.define(custom_path:)
    ENV['SCRIPT_CUSTOM_RESOURCES'] = custom_path
  end
end
