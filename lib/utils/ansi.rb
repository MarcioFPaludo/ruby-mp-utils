# frozen_string_literal: true

require_relative 'constants'

# The ANSI class is responsible for generating ANSI codes for text styling in terminals.  
# It allows the combination of multiple style and color codes.  
#
# @example  
#   ansi = ANSI.new(:bold)  
#   puts ansi.to_s # => "\e[1m"  
#
# @example  
#   ansi = ANSI.new([:bold, :red])  
#   puts ansi.to_s # => "\e[1;31m"  
class ANSI
  # Hash that maps style and color names to their respective ANSI codes.  
  CODES_HASH = {
    reset_all: 0,

    # Effects
    bold: 1,
    faint: 2,
    italic: 3,
    underlined: 4,
    blinking: 5,
    inverse: 7,
    hidden: 8,
    strike: 9,
    plain: 21,

    # Remove Effects
    remove_bold: 22,
    remove_faint: 22,
    remove_italic: 23,
    remove_underlined: 24,
    remove_blinking: 25,
    remove_inverse: 27,
    remove_hidden: 28,
    remove_strike: 29,
    remove_plain: 24,

    # Colors
    black: 30,
    red: 31,
    green: 32,
    yellow: 33,
    blue: 34,
    magenta: 35,
    cyan: 36,
    white: 37,
    reset_color: 39,
    rgb_format: [38, 2],
    numeric_format: [38, 5],

    # Background Colors
    background_black: 40,
    background_red: 41,
    background_green: 42,
    background_yellow: 43,
    background_blue: 44,
    background_magenta: 45,
    background_cyan: 46,
    background_white: 47,
    background_rgb_format: [48, 2],
    background_numeric_format: [48, 5],
    reset_background: 49
  }.freeze

  # @return [Array<Integer>] the ANSI codes stored in the instance.  
  attr_reader :codes

  # Initializes a new instance of the ANSI class.  
  #
  # @param code [Array<Symbol>, Symbol, String] One or more ANSI codes represented as symbols, integers, or strings.  
  def initialize(code)
    @codes = if code.is_a?(Array)
               ANSI.normalize_array_codes(code)
             elsif code.is_a?(Symbol)
               [CODES_HASH[code]]
             else
               ANSI.normalize_array_codes(code.split(';'))
             end
  end

  # Adds ANSI codes from another instance of the ANSI class.  
  #
  # @param ansi [ANSI] The instance of the ANSI class whose codes will be added.  
  # @return [ANSI] A new instance of the ANSI class with the combined codes.  
  # @raise [RuntimeError] If the argument is not an instance of the ANSI class.  
  def append(ansi)
    raise 'Needs be an instance of ANSI' unless ansi.is_a?(ANSI)

    ANSI.new(@codes.union(ansi.codes))
  end

  # Adds ANSI codes from another instance of the ANSI class and updates the current instance.  
  #
  # @param ansi [ANSI] The instance of the ANSI class whose codes will be added.  
  # @return [void]  
  def append!(ansi)
    @codes = append(ansi).codes
  end

  # Converts the ANSI codes stored in the instance to a formatted string.  
  #
  # @return [String] The formatted string with the ANSI codes.  
  def to_s
    "\e[#{@codes.flatten.join(';')}m"
  end

  # Normalizes an array of codes, converting symbols and strings to their respective ANSI codes.  
  #
  # @param array [Array<Symbol, String, Integer>] An array of codes to be normalized.  
  # @return [Array<Integer>] The normalized array of ANSI codes.  
  def self.normalize_array_codes(array)
    array.map do |value|
      next normalize_array_codes(value) if value.is_a?(Array)
      next value if value.is_a?(Integer)
      next CODES_HASH[value] if value.is_a?(Symbol)
      next value.to_i if value.match?(CONSTANTS::ONLY_DIGITS_REGEX)

      CODES_HASH[value.to_sym]
    end
  end
end
