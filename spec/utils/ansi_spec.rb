# frozen_string_literal: true

require_relative '../../lib/utils/ansi'

RSpec.describe ANSI do
  describe '.remove_from_string' do
    it 'removes ANSI escape codes from a string' do
      string_with_ansi = "\e[31mHello\e[0m World"
      expect(ANSI.remove_from_string(string_with_ansi)).to eq('Hello World')
    end

    it 'returns the same string if there are no ANSI codes' do
      plain_string = 'Hello World'
      expect(ANSI.remove_from_string(plain_string)).to eq('Hello World')
    end
  end
  
  describe '#initialize' do
    it 'initializes with a symbol' do
      ansi = ANSI.new(:bold)
      expect(ansi.codes).to eq([1])
    end

    it 'initializes with an array of symbols' do
      ansi = ANSI.new(%i[bold red])
      expect(ansi.codes).to eq([1, 31])
    end

    it 'initializes with a string' do
      ansi = ANSI.new('bold;red')
      expect(ansi.codes).to eq([1, 31])
    end
  end

  describe '#append' do
    it 'adds codes from another ANSI instance' do
      ansi1 = ANSI.new(:bold)
      ansi2 = ANSI.new(:red)
      combined_ansi = ansi1.append(ansi2)
      expect(combined_ansi.codes).to eq([1, 31])
    end

    it 'raises an error if the argument is not an instance of ANSI' do
      ansi = ANSI.new(:bold)
      expect { ansi.append('not_ansi') }.to raise_error('Needs be an instance of ANSI')
    end
  end

  describe '#append!' do
    it 'adds codes from another ANSI instance and updates the current instance' do
      ansi1 = ANSI.new(:bold)
      ansi2 = ANSI.new(:red)
      ansi1.append!(ansi2)
      expect(ansi1.codes).to eq([1, 31])
    end
  end

  describe '#to_s' do
    it 'converts the ANSI codes to a formatted string' do
      ansi = ANSI.new(%i[bold red])
      expect(ansi.to_s).to eq("\e[1;31m")
    end
  end

  describe '.normalize_array_codes' do
    it 'normalizes an array of symbols' do
      codes = ANSI.normalize_array_codes(%i[bold red])
      expect(codes).to eq([1, 31])
    end

    it 'normalizes an array of strings' do
      codes = ANSI.normalize_array_codes(%w[bold red])
      expect(codes).to eq([1, 31])
    end

    it 'normalizes an array of integers' do
      codes = ANSI.normalize_array_codes([1, 31])
      expect(codes).to eq([1, 31])
    end

    it 'normalizes a mixed array of symbols, strings, and integers' do
      codes = ANSI.normalize_array_codes([:bold, 'red', 32])
      expect(codes).to eq([1, 31, 32])
    end
  end
end
