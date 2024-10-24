# frozen_string_literal: true

# @!visibility private
module CONSTANTS
  ONLY_DIGITS_REGEX = /^\d+$/.freeze

  # @!visibility private
  module ANSI
    TOKEN_REGEX = /\\e\[(\d|;)+m/.freeze
    COLOR_DIGITS_REGEX = /^(\d+);(\d+);(\d+)|(\d+)$/.freeze
    COLOR_TOKEN_VALUE = '(?:[\w|\d]+|\d+\;\d+\;\d+)(?::[\w|\d]+|:\d+;\d+;\d+)?'
    COLORS = %r{<color:(#{COLOR_TOKEN_VALUE})>((?:(?!<color:#{COLOR_TOKEN_VALUE}>|</color>).)*)</color>}m.freeze
    EFFECTS = %r{<effect:(\w+)>((?:(?!<effect:\w+>|</effect>).)*)</effect>}m.freeze
  end
end
