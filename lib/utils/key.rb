# frozen_string_literal: true

# Message Key is Used to include find replace contents inside a messages.
class Key
  attr_reader :value

  def initialize(value)
    @value = value.to_s
  end

  def ==(other)
    self.class == other.class && @value == other.value
  end

  def to_s
    "#{Key.prefix}#{@value}#{Key.suffix}"
  end
end

# Static Methods
class Key
  def self.find_keys_in(value)
    ep = Regexp.escape(prefix)
    es = Regexp.escape(suffix)
    value.to_s.scan(/#{ep}[^#{ep}#{es}]+#{es}/).map do |key|
      Key.new(key.gsub(/(#{ep})|(#{es})/, ''))
    end
  end

  def self.prefix
    '<||'
  end

  def self.suffix
    '||>'
  end
end
