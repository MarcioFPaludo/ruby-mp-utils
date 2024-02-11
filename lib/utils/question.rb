# frozen_string_literal: true

require_relative 'message'
require_relative 'array'

# The Question class facilitates the creation and management of interactive questions in the console.
# It provides methods to validate and return user input as various data types including boolean,
# float, integer, options (from a list), and string.
class Question
  # Initializes a new instance of the Question class.
  #
  # @param message [String] The question message to be displayed to the user.
  def initialize(message)
    @message = message
  end

  # Prompts the user with a boolean question and returns the answer as true or false.
  #
  # @param error_message [String, nil] Custom error message for invalid inputs.
  # @return [Boolean] True if the user answers affirmatively, otherwise false.
  def bool_answer(error_message: nil)
    error = error_message || File.join('question', 'error', 'bool')
    bool_sufix = Message.new(File.join('question', 'bool_sufix'))
    result = read_input("#{@message} #{bool_sufix}", error_message: error) do |input|
      input.match?(/^((Y|y)((E|e)(S|s))*)|((N|n)(O|o)*)$/)
    end

    result.match?(/^(Y|y)((E|e)(S|s))*$/)
  end

  # Prompts the user for a floating-point number and returns the value.
  #
  # @param error_message [String, nil] Custom error message for invalid inputs.
  # @return [Float] The user's input converted to a float.
  def float_answer(error_message: nil)
    error = error_message || File.join('question', 'error', 'float')
    string_answer(regex: /^\d+\.\d+$/, error_message: error).to_f
  end

  # Prompts the user for an integer and returns the value.
  #
  # @param error_message [String, nil] Custom error message for invalid inputs.
  # @return [Integer] The user's input converted to an integer.
  def integer_answer(error_message: nil)
    error = error_message || File.join('question', 'error', 'integer')
    string_answer(regex: /^\d+$/, error_message: error).to_i
  end

  # Prompts the user to select an option from a given list and returns the selected option.
  #
  # @param options [Array] The list of options for the user to choose from.
  # @param error_message [String, nil] Custom error message for invalid inputs.
  # @raise [RuntimeError] If options is not an Array or is empty.
  # @return [Object] The selected option from the list. If options count is 1 return the first element.
  def option_answer(options, error_message: nil)
    raise 'Options should be an Array' unless options.is_a?(Array)
    raise 'Options should not be empty' if options.empty?
    return options.first if options.count == 1

    options.list_all_elements
    index = read_index_input(count: options.count, error_message: error_message)
    options[index]
  end

  # Prompts the user for a string that matches a given regular expression.
  #
  # @param regex [Regexp, nil] The regular expression the user's input must match.
  # @param error_message [String, nil] Custom error message for invalid inputs.
  # @return [String] The user's input if it matches the given regex.
  def string_answer(regex: nil, error_message: nil)
    error = error_message || File.join('question', 'error', 'regex')
    read_input(error_message: error) do |input|
      regex.nil? || input.match?(regex)
    end
  end

  private

  # Displays a message to the user and returns their input, if it satisfies the given condition.
  #
  # @param message [String] The message to display to the user.
  # @param error_message [String] The error message to display for invalid inputs.
  # @yieldparam input [String] The user's input to validate.
  # @yieldreturn [Boolean] True if the input is valid, otherwise false.
  # @return [String] The user's valid input.
  def read_input(message = @message, error_message:)
    loop do
      puts message
      input = $stdin.gets.chomp
      return input if yield input

      puts Message.new(error_message)
    end
  end

  # Reads an index input from the user, ensuring it falls within a specified range.
  #
  # This method prompts the user to enter an index number. It validates the input to ensure
  # it is an integer within the range of 0 to (count - 1). If the input is invalid, an error
  # message is displayed, and the user is prompted again.
  #
  # @param count [Integer] The count of items, setting the upper limit of the valid index range.
  # @param error_message [String, nil] Custom error message for invalid index inputs.
  #                              Defaults to the path 'question/error/index' if nil.
  # @return [Integer] The user's input adjusted to be zero-based (input - 1) and validated to be within the range.
  def read_index_input(count:, error_message: nil)
    loop do
      error = error_message || File.join('question', 'error', 'index')
      index = integer_answer(error_message: error) - 1
      return index if index >= 0 && index < count

      puts Message.new(error)
    end
  end
end
