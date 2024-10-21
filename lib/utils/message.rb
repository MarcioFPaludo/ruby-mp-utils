# frozen_string_literal: true

require_relative File.join('..', 'resources', 'path_helper')
require_relative 'key'

# The Message class represents a mechanism for dynamically handling and formatting messages.  
# It supports the substitution of placeholders within a message template with actual data.  
# The class leverages file-based message templates, allowing for easy localization or
# customization of messages.  
#
# It integrates seamlessly with the Resources module to access these templates from
# a customizable path set via the "SCRIPT_CUSTOM_RESOURCES" environment variable or
# from a default library path.  
#
# @example Creating a new Message instance and formatting it
#   # Assuming "hellow_world" is a file that says "Hello, world!"
#   message = Message.new("hellow_world")
#   puts message.to_s # => "Hello, world!"
class Message
  attr_reader :message

  # Initializes a new instance of the Message class with a given message template.
  #
  # @param message [String] The message template to be used.
  # @param replaces [Hash] Used to replace all occurrences of a key with its value.
  def initialize(message, replaces: nil)
    raise 'Messsage replaces content need be a Hash' if !replaces.nil? && !replaces.is_a?(Hash)

    @to_replace = replaces
    @message = message
  end

  # Compares two Message instances for equality based on their message content.
  #
  # @param other [Message] The other Message instance to compare with.
  # @return [Boolean] True if the messages are equal, otherwise false.
  def ==(other)
    self.class == other.class && @message == other.message
  end

  # Converts the message template into a string, replacing any placeholders with actual data.  
  # This method searches for keys within the message and replaces them with corresponding
  # content from message files located in either the custom path or the library path and appling
  # the given replaces.  
  # If the file name have the suffix ".aas.txt", the ANSIStyleManager will be applied to the file.  
  #
  # @return [String] The formatted message with placeholders substituted with actual content.
  def to_s
    new_message = replace_message_keys(String.new(@message))
    replace_all_to_replace_elements(new_message)
  end

  private

  # Determines the custom path for message files, if set through the "SCRIPT_CUSTOM_RESOURCES" environment variable.  
  #
  # @return [String, nil] The custom path for message files, or nil if not set.
  def custom_path
    path = Resources.custom_path
    return nil if path.nil?

    File.join(path, 'messages')
  end

  # Provides the default library path for message files.  
  # This path is used as a fallback when a message file is not found in the custom path.  
  #
  # @return [String] The path to the default library of message files.
  def library_path
    File.join(Resources.library_path, 'messages')
  end

  # Replaces keys found in the original message with their corresponding values.  
  #
  # @param message [String] The original message with keys to be replaced.
  # @return [String] The message with keys replaced by their corresponding values.
  def replace_message_keys(message)
    keys = Key.find_keys_in(message)
    return recover_message_with(message) if keys.empty?

    keys.each do |key|
      key_message = recover_message_with(key.value)
      message.gsub!(key.to_s, key_message) if key_message != key.value
    end

    message
  end

  # Replaces all placeholders in the message with their corresponding values from the @to_replace hash.  
  #
  # @param message [String] The message with placeholders to replace.
  # @return [String] The message with all placeholders replaced with actual content.
  def replace_all_to_replace_elements(message)
    return message if @to_replace.nil?

    @to_replace.each do |key, value|
      if key.is_a?(Key)
        message.gsub!(key.to_regexp, value.to_s)
      else
        message.gsub!(/#{Regexp.escape(key.to_s)}/, value.to_s)
      end
    end

    message
  end

  # Attempts to recover and return the content of a message file identified by the file_name parameter.  
  # It first looks in the custom path (if defined) and then in the library path.  
  #
  # @param file_name [String] The name of the file containing the message content to be recovered.
  # @return [String] The content of the message file, or the file_name itself if the file cannot be found.
  def recover_message_with(file_name)
    path = custom_path
    unless path.nil?
      message = recover_content_with(path, file_name)
      return message unless message.nil?
    end

    message = recover_content_with(library_path, file_name)
    return message unless message.nil?

    file_name
  end

  # Reads and returns the content of a message file located at a specific path.  
  # If the file name have the suffix ".aas.txt", the ANSIStyleManager will be applied to the file.  
  #
  # @param path [String] The path where the message file is located.
  # @param file_name [String] The name of the file to be read.
  # @return [String, nil] The content of the message file, or nil if the file does not exist.
  def recover_content_with(path, file_name)
    aas_file_path = File.join(path, "#{file_name}.aas.txt")
    if File.exist?(aas_file_path)
      content = File.read(aas_file_path)
      return ANSIStyleManager.new(content).to_s
    end

    file_path = File.join(path, "#{file_name}.txt")
    return nil unless File.exist?(file_path)

    File.read(file_path)
  end
end
