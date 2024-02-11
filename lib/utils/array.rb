# frozen_string_literal: true

class Array
  def list_all_elements
    index_size = count.to_s.count
    each_index do |index|
      puts "|#{index.to_s.rjust(index_size)}| #{options[index]}"
    end
  end
end
