# frozen_string_literal: true

# Extension to Ruby's Array class to enhance functionality.  
class Array
  # Lists all elements in the array with their index.  
  #
  # This method outputs each element of the array to the console, prefixed by its index (1-based).  
  # The index is right-justified based on the length of the array, ensuring a tidy, column-aligned output.  
  #
  # @example
  #   # output for a 3-element array:  
  #   |1| Element 1  
  #   |2| Element 2  
  #   |3| Element 3  
  #
  # @return [void]
  def list_all_elements
    index_size = count.to_s.length
    each_index do |index|
      puts "|#{(index + 1).to_s.rjust(index_size)}| #{self[index]}"
    end
  end
end
