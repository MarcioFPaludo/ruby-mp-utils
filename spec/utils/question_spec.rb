# frozen_string_literal: true

require_relative '../../lib/utils/question'

RSpec.describe Question do
  response = 'This message should be replaced'

  describe '#string_answer' do
    let(:input_response) { 'My name is Alice' }
    let(:question) { Question.new(message) }
    let(:message) { 'What is your name?' }
    let(:regex) { /^(\w|\s)+$/ }

    it "should return the given user's input" do
      expected_output = <<~OUTPUT
        #{message}
      OUTPUT

      allow($stdin).to receive(:gets).and_return("#{input_response} ;)")
      expect { response = question.string_answer }.to output(expected_output).to_stdout
      expect(response).to eq("#{input_response} ;)")
    end

    it "should returns the user's input if it matches the given regex" do
      expected_output = <<~OUTPUT
        #{message}
        Message does not meet the requested standard.
        Please provide a message within the expected standard.
        #{message}
      OUTPUT

      allow($stdin).to receive(:gets).and_return("#{input_response} ;)", input_response)
      expect { response = question.string_answer(regex: regex) }.to output(expected_output).to_stdout
      expect(response).to eq(input_response)
    end
  end

  describe '#bool_answer' do
    let(:question) { Question.new('Is Ruby fun to learn?') }
    let(:expected_output) do
      <<~OUTPUT
        Is Ruby fun to learn? (Yes/No/Y/N)
        You need to answer with "Yes or No" only.
        These are the valid response options: Yes, No, Y, N
        Note: You can use both lowercase and uppercase letters for the answers.
        Is Ruby fun to learn? (Yes/No/Y/N)
      OUTPUT
    end

    it "should returns true for a 'yes' answer" do
      allow($stdin).to receive(:gets).and_return('batata', 'yes')
      expect { response = question.bool_answer }.to output(expected_output).to_stdout
      expect(response).to eq(true)
    end

    it "should returns false for a 'no' answer" do
      response = true

      allow($stdin).to receive(:gets).and_return('o', 'no')
      expect { response = question.bool_answer }.to output(expected_output).to_stdout
      expect(response).to eq(false)
    end

    it "should returns true for a 'Y' answer" do
      allow($stdin).to receive(:gets).and_return('es', 'Y')
      expect { response = question.bool_answer }.to output(expected_output).to_stdout
      expect(response).to eq(true)
    end

    it "should returns false for a 'N' answer" do
      response = true

      allow($stdin).to receive(:gets).and_return('s', 'N')
      expect { response = question.bool_answer }.to output(expected_output).to_stdout
      expect(response).to eq(false)
    end
  end

  describe '#float_answer' do
    let(:message) { 'Enter a floating-point number:' }
    let(:question) { Question.new(message) }

    it 'returns the input converted to a float' do
      expected_output = <<~OUTPUT
        #{message}
        You need to provide a numeric value with decimal places.
        Example: 3143.14
        #{message}
        You need to provide a numeric value with decimal places.
        Example: 3143.14
        #{message}
      OUTPUT

      allow($stdin).to receive(:gets).and_return('a', '3', '3.14')
      expect { response = question.float_answer }.to output(expected_output).to_stdout
      expect(response).to eq(3.14)
    end
  end

  describe '#integer_answer' do
    let(:question) { Question.new(message) }
    let(:message) { 'Enter an integer:' }

    it 'returns the input converted to an integer' do
      expected_output = <<~OUTPUT
        #{message}
        You need to provide an integer numeric value.
        Example: 123456
        #{message}
        You need to provide an integer numeric value.
        Example: 123456
        #{message}
      OUTPUT

      allow($stdin).to receive(:gets).and_return('b', '3.14', '42')
      expect { response = question.integer_answer }.to output(expected_output).to_stdout
      expect(response).to eq(42)
    end
  end

  describe '#option_answer' do
    options = %w[option1 option2 option3]
    let(:question) { Question.new('Choose an option:') }

    it 'raises an error if options is not an array' do
      expect { question.option_answer('not an array') }.to raise_error(RuntimeError, 'Options should be an Array')
    end

    it 'raises an error if options array is empty' do
      expect { question.option_answer([]) }.to raise_error(RuntimeError, 'Options should not be empty')
    end

    it 'returns first option if array has only one element' do
      option = 'Single Option'
      expect(question.option_answer([option])).to eq(option)
    end

    it 'returns the selected option from the list' do
      expected_output = <<~OUTPUT
        |1| option1
        |2| option2
        |3| option3
        Choose an option:
        You need to provide an integer numeric value.
        Example: 123456
        Choose an option:
        The index value needs to be within the above listing.
        Choose an option:
      OUTPUT

      allow($stdin).to receive(:gets).and_return("A\n", "5\n", "2\n")
      expect { response = question.option_answer(options) }.to output(expected_output).to_stdout
      expect(response).to eq('option2')
    end
  end
end
