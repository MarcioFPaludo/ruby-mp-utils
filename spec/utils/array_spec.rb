# frozen_string_literal: true

require_relative '../../lib/utils/array'

RSpec.describe Array do
  describe '#list_all_elements' do
    context 'when the array is empty' do
      it 'prints nothing' do
        expect { [].list_all_elements }.to output('').to_stdout
      end
    end

    context 'when the array has one element' do
      it 'prints the element with its index' do
        expect { ['Element'].list_all_elements }.to output("|1| Element\n").to_stdout
      end
    end

    context 'when the array has multiple elements' do
      it 'prints all elements with their indices, aligned properly' do
        array = %w[First Second Third]
        expected_output = <<~OUTPUT
          |1| First
          |2| Second
          |3| Third
        OUTPUT
        expect { array.list_all_elements }.to output(expected_output).to_stdout
      end
    end

    context 'with a larger set of elements affecting index alignment' do
      it 'adjusts the index alignment based on the number of elements' do
        array = (1..12).to_a
        expected_output = <<~OUTPUT
          | 1| 1
          | 2| 2
          | 3| 3
          | 4| 4
          | 5| 5
          | 6| 6
          | 7| 7
          | 8| 8
          | 9| 9
          |10| 10
          |11| 11
          |12| 12
        OUTPUT
        expect { array.list_all_elements }.to output(expected_output).to_stdout
      end
    end
  end
end
