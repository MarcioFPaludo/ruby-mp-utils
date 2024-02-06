# frozen_string_literal: true

require_relative File.join('..', 'resources', 'path_helper')
require_relative 'key'

# Message Helper Class
class Message
  attr_reader :message

  def initialize(message)
    @message = message
  end

  def ==(other)
    self.class == other.class && @message == other.message
  end

  def to_s
    new_message = String.new(@message)
    keys = Key.find_keys_in(@message)

    if keys.count.positive?
      keys.each do |key|
        new_message.gsub!(key.to_s, recover_message_with(key.value))
      end
    else
      new_message = recover_message_with(new_message)
    end

    new_message
  end
end

# Private Methods
class Message
  private

  def custom_path
    path = Resources.custom_path
    return nil if path.nil?

    File.join(path, 'messages')
  end

  def library_path
    File.join(Resources.library_path, 'messages')
  end

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

  def recover_content_with(path, file_name)
    file_path = File.join(path, "#{file_name}.txt")
    return nil unless File.exist?(file_path)

    File.read(file_path)
  end
end
