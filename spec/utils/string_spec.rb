# frozen_string_literal: true

require_relative '../../lib/utils/string'

RSpec.describe String do
  describe '#remove_ansi' do
    it 'removes ANSI escape codes from the string' do
      string_with_ansi = "\e[31mHello\e[0m World"
      expect(string_with_ansi.remove_ansi).to eq('Hello World')
    end

    it 'returns the same string if there are no ANSI codes' do
      plain_string = 'Hello World'
      expect(plain_string.remove_ansi).to eq('Hello World')
    end
  end

  describe '#to_key' do
    it 'converts the string to a Key object' do
      string = 'my_key'
      key = string.to_key
      expect(key).to be_a(Key)
      expect(key.value).to eq('my_key')
    end
  end

  describe '#to_question' do
    it 'converts the string to a Question object' do
      string = 'Is this a question?'
      question = string.to_question
      expect(question).to be_a(Question)
    end
  end

  describe '#to_message' do
    it 'converts the string to a Message object without replacements' do
      string = 'This is a message'
      message = string.to_message
      expect(message).to be_a(Message)
      expect(message.message).to eq('This is a message')
    end

    it 'converts the string to a Message object with replacements' do
      string = 'Hello, <||name||>s'
      replacements = { name: 'Alice' }
      message = string.to_message(replaces: replacements)
      expect(message).to be_a(Message)
      expect(message.message).to eq(string)
    end
  end
end
