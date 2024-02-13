# frozen_string_literal: true

require_relative '../../lib/utils/key'

RSpec.describe Key do
  value = 'test_value'

  describe '.prefix' do
    it 'should return the key prefix' do
      expect(Key.prefix).to eq('<||')
    end
  end

  describe '.suffix' do
    it 'should return the key suffix' do
      expect(Key.suffix).to eq('||>')
    end
  end

  describe '#value' do
    it 'should return initialized value' do
      expect(Key.new(value).value).to eq(value)
    end
  end

  describe '#to_s' do
    it 'should return initialized value with prefix and suffix' do
      expect(Key.new(value).to_s).to eq("#{Key.prefix}#{value}#{Key.suffix}")
    end
  end

  describe '#to_regexp' do
    it 'should return the escaped Regexp representation of Key.to_s return' do
      dummy_key = Key.new(value)
      expect(dummy_key.to_regexp).to eq(/#{Regexp.escape(dummy_key.to_s)}/)
    end
  end

  describe '#equals' do
    it 'instances with same value should be equal' do
      expect(Key.new(value)).to eq(Key.new(value))
    end
  end

  describe '.find_keys_in(value)' do
    it 'should find 2 keys' do
      value = '<|| <||first||> Valor fake teste <||second||>   teste  ||>'

      expect(Key.find_keys_in(value)).to eq([Key.new('first'), Key.new('second')])
    end
  end
end
