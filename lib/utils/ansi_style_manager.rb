# frozen_string_literal: true

require_relative 'constants'
require_relative 'ansi'

# The ANSIStyleManager class is responsible for managing and applying ANSI styles to a given string.
# It can replace tokens in the string with corresponding ANSI codes for colors and effects.
#
# @example
#   manager = ANSIStyleManager.new("Hello <color:red>World</color>")
#   puts manager.to_s # => "Hello \e[31mWorld\e[39m"
class ANSIStyleManager
  # @return [String] the string to which ANSI styles will be applied.
  attr_reader :string

  # Initializes a new instance of the ANSIStyleManager class.
  #
  # @param string [String] The string to which ANSI styles will be applied.
  # @raise [RuntimeError] If the argument is not a string.
  def initialize(string)
    raise 'Need initialize with a string' unless string.is_a?(String)

    @string = String.new(string)
  end

  # Replaces all color and effect tokens in the string with corresponding ANSI codes.
  #
  # @return [void]
  def replace_all_tokens!
    replace_color_tokens!
    replace_effect_tokens!
  end

  # Replaces all color tokens in the string with corresponding ANSI codes.
  #
  # @return [void]
  def replace_color_tokens!
    scan_while_find(CONSTANTS::ANSI::COLORS) do |value|
      colors = value.first.split(':')

      replace_tokens_with!(
        ansi_token: color_prefix(color: colors[0], background: colors[1]),
        ansi_reset_token: ANSI.new(%i[reset_background reset_color]),
        to_replace: "<color:#{value.first}>#{value.last}</color>",
        preserve_reset_token: false,
        text: value.last
      )
    end
  end

  # Replaces all effect tokens in the string with corresponding ANSI codes.
  #
  # @return [void]
  def replace_effect_tokens!
    scan_while_find(CONSTANTS::ANSI::EFFECTS) do |value|
      replace_tokens_with!(
        ansi_reset_token: ANSI.new("remove_#{value.first.downcase}"),
        to_replace: "<effect:#{value.first}>#{value.last}</effect>",
        ansi_token: ANSI.new(value.first.downcase),
        preserve_reset_token: true,
        text: value.last
      )
    end
  end

  # Converts the string with all tokens replaced by corresponding ANSI codes.
  #
  # @return [String] The string with ANSI codes applied.
  def to_s
    replace_all_tokens!
    @string
  end

  private

  # Generates the ANSI prefix for a given color and background.
  #
  # @param color [String] The color name or code.
  # @param background [String, nil] The background color name or code.
  # @return [ANSI] The ANSI instance representing the color and background.
  def color_prefix(color:, background:)
    color_ansi = generate_color_ansi(color, is_background: false)
    return color_ansi.to_s if background.nil?

    generate_color_ansi(background, is_background: true).append(color_ansi)
  end

  # Generates the ANSI instance for a given color.
  #
  # @param color [String] The color name or code.
  # @param is_background [Boolean] Whether the color is for the background.
  # @return [ANSI] The ANSI instance representing the color.
  def generate_color_ansi(color, is_background:)
    digit_values = color.scan(CONSTANTS::ANSI::COLOR_DIGITS_REGEX).flatten.compact

    if [1, 3].include?(digit_values.count)
      format = digit_values.count == 1 ? 5 : 2
      type = is_background ? 48 : 38

      return ANSI.new([type, format].concat(digit_values))
    elsif color.match?(/^reset$/)
      return ANSI.new(is_background ? :reset_background : :reset_color)
    end

    ANSI.new(is_background ? "background_#{color}" : color)
  end

  # Replaces tokens in the string with corresponding ANSI codes.
  #
  # @param text [String] The text to be styled.
  # @param to_replace [String] The token to be replaced.
  # @param ansi_token [ANSI] The ANSI instance representing the style.
  # @param ansi_reset_token [ANSI] The ANSI instance representing the reset style.
  # @param preserve_reset_token [Boolean] Whether to preserve the reset token in the text.
  # @return [void]
  def replace_tokens_with!(text:, to_replace:, ansi_token:, ansi_reset_token:, preserve_reset_token:)
    colored_text = text.gsub(ansi_reset_token.to_s, "#{ansi_reset_token}#{ansi_token}") if preserve_reset_token
    colored_text = text.gsub(ansi_reset_token.to_s, ansi_token.to_s) unless preserve_reset_token
    @string.gsub!(to_replace, "#{ansi_token}#{colored_text}#{ansi_reset_token}")
  end

  # Scans the string for tokens matching the given regex and processes them with the provided block.
  #
  # @param scan_regex [Regexp] The regex to scan for tokens.
  # @yieldparam value [Array<String>] The matched tokens.
  # @return [void]
  def scan_while_find(scan_regex, &block)
    result = @string.scan(scan_regex)
    while result.count.positive?
      result.each do |value|
        block.call(value)
      end

      result = @string.scan(scan_regex)
    end
  end
end
