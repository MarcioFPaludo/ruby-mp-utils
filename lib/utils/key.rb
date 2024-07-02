# frozen_string_literal: true

# The Key class is designed to encapsulate strings within a specific prefix and suffix,
# allowing for easy identification and manipulation of placeholders within messages.
# This can be particularly useful in templating systems where placeholders need
# to be dynamically replaced with actual content.
#
# @example Creating a new Key and converting it to a string
#   key = Key.new("username")
#   key.to_s # => "<||username||>"
#
# @example Finding keys within a string
#   keys = Key.find_keys_in("Hello, <||username||>! Your code is <||code||>.")
#   keys.map(&:to_s) # => ["<||username||>", "<||code||>"]
class Key
  # @!attribute [r] value
  #   @return [String] the value of the key without the prefix and suffix.
  attr_reader :value

  # Initializes a new Key with the given value.
  #
  # @param value [#to_s] the value to be encapsulated by the Key.
  def initialize(value)
    @value = value.to_s
  end

  # Checks equality of two Key objects based on their value.
  #
  # @param other [Key] the other Key object to compare with.
  # @return [Boolean] true if both Keys have the same value, false otherwise.
  def ==(other)
    self.class == other.class && @value == other.value
  end

  # Returns the string representation of the Key, including its prefix and suffix.
  #
  # @return [String] the string representation of the Key.
  def to_s
    "#{Key.prefix}#{@value}#{Key.suffix}"
  end

  # Returns the escaped Regexp representation of the Key.to_s return.
  #
  # @return [Regexp] the escaped regexp representation of the Key.to_s return.
  def to_regexp
    /#{Regexp.escape(to_s)}/
  end

  # Finds and returns all Key instances within the given string.
  #
  # @param value [#to_s] the string to search for keys.
  # @return [Array<Key>] an array of Key instances found within the given string.
  def self.find_keys_in(value)
    ep = Regexp.escape(prefix)
    es = Regexp.escape(suffix)
    value.to_s.scan(/#{ep}([^#{ep}#{es}]+)#{es}/).map do |key|
      Key.new(key.first)
    end
  end

  # Returns the prefix used to identify the start of a Key in a string.
  #
  # @return [String] the prefix.
  def self.prefix
    '<||'
  end

  # Returns the suffix used to identify the end of a Key in a string.
  #
  # @return [String] the suffix.
  def self.suffix
    '||>'
  end
end
