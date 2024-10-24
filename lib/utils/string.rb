# frozen_string_literal: true

# This class provides additional methods to the standard Ruby String class,
# allowing for the removal of ANSI codes, and conversion to Key, Question,
# and Message objects.  
class String
  # Removes ANSI escape codes from the string.
  #
  # @return [String] a new string with ANSI codes removed.
  def remove_ansi
    ANSI.remove_from_string(self)
  end

  # Converts the string to a Key object.
  #
  # @return [Key] a new Key object initialized with the string.
  def to_key
    Key.new(self)
  end

  # Converts the string to a Question object.
  #
  # @return [Question] a new Question object initialized with the string.
  def to_question
    Question.new(self)
  end

  # Converts the string to a Message object.
  #
  # @param replaces [Hash, nil] optional replacements to be applied in the message.
  # @return [Message] a new Message object initialized with the string and optional replacements.
  def to_message(replaces: nil)
    Message.new(self, replaces: replaces)
  end
end
