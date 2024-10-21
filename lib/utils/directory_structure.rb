# frozen_string_literal: true

require 'yaml'

# Class to represent and process a directory structure.  
# It can be initialized with a hash or a YAML file.  
#
# ## Using HASH  
#
# The following example shows how to use DirectoryStructure with a hash.  
# ```ruby
# hash = {
#   'lib' => {
#     'version.rb' => nil,
#     'source' => [
#       'file_1.rb',
#       'file_2.rb',
#       'file_3.rb'
#     ],
#     'resource' => {
#       'images' => [
#         'potato.png',
#         'fries.jpeg',
#         'franch_fries.png'
#       ],
#       'scripts' => {
#         validation: 'teste.rb',
#         sorting: [
#           'shellsort.rb',
#           'quicksort.rb'
#         ],
#         'build.rb' => nil
#       }
#     },
#     generated: 'file.generated.rb'
#   }
# }
# directory_structure = DirectoryStructure.new(hash)  
# puts "That is my directory structure:\n#{directory_structure}"  
#   
# # Output:  
# # That is my directory structure:  
# # lib  
# # ╠═ version.rb
# # ╠═ source
# # ║  ╠═ file_1.rb
# # ║  ╠═ file_2.rb
# # ║  ╚═ file_3.rb
# # ╠═ resource
# # ║  ╠═ images
# # ║  ║  ╠═ potato.png
# # ║  ║  ╠═ fries.jpeg
# # ║  ║  ╚═ franch_fries.png
# # ║  ╚═ scripts
# # ║     ╠═ validation
# # ║     ║  ╚═ teste.rb
# # ║     ╠═ sorting
# # ║     ║  ╠═ shellsort.rb
# # ║     ║  ╚═ quicksort.rb
# # ║     ╚═ build.rb
# # ╚═ generated
# #    ╚═ file.generated.rb
# ```
#
# ## Using a YAML/YML File  
#
# First, you need to create a yml file.  
#
# Example:  
# ```yml
# lib:
#   version.rb:
#   source:
#   - file_1.rb
#   - file_2.rb
#   - file_3.rb
#   resource:
#     images:
#     - potato.png
#     - fries.jpeg
#     - franch_fries.png
#     scripts:
#       validation: teste.rb
#       sorting:
#       - shellsort.rb
#       - quicksort.rb
#       build.rb:
#   generated: file.generated.rb
# ```
#
# Considering that the file path is passed as a reference.  
#
# You can initialize the class as in the example below:  
#
# ```ruby  
# path = 'Replace/By/Your/YAML/FILE/PATH'  
# directory_structure = DirectoryStructure.new(path)  
# puts "That is my directory structure:\n#{directory_structure}"  
# 
# # Output:
# # That is my directory structure:
# # lib
# # ╠═ version.rb
# # ╠═ source
# # ║  ╠═ file_1.rb
# # ║  ╠═ file_2.rb
# # ║  ╚═ file_3.rb
# # ╠═ resource
# # ║  ╠═ images
# # ║  ║  ╠═ potato.png
# # ║  ║  ╠═ fries.jpeg
# # ║  ║  ╚═ franch_fries.png
# # ║  ╚═ scripts
# # ║     ╠═ validation
# # ║     ║  ╚═ teste.rb
# # ║     ╠═ sorting
# # ║     ║  ╠═ shellsort.rb
# # ║     ║  ╚═ quicksort.rb
# # ║     ╚═ build.rb
# # ╚═ generated
# #    ╚═ file.generated.rb
# ```
class DirectoryStructure
  # Initializes the DirectoryStructure object.  
  #
  # @param content [Hash, String] A hash representing the directory structure or a path to a YAML file.  
  # @raise [RuntimeError] If the content is not a Hash or a valid YAML file path.  
  def initialize(content)
    if content.is_a?(Hash)
      @dir_hash = content
    elsif File.exist?(content)
      @dir_hash = YAML.load_file(content)
    else
      raise 'Need be initialized with a Hash or yaml file path'
    end
  end

  # Converts the directory structure to a string representation.  
  #
  # @return [String] The string representation of the directory structure.  
  def to_s
    @output = String.new('')
    process_node(@dir_hash)
    @output
  end

  private

  # Generates the indentation string based on the key.  
  #
  # @param key [Symbol] The key indicating the type of indentation.  
  # @return [String] The indentation string.  
  def generate_indent(key)
    { middle: '║  ', last: '   ' }[key] || ''
  end

  # Concatenates the node to the output string with the given prefix and indentation.  
  #
  # @param node [String] The node to be concatenated.  
  # @param prefix [Symbol] The prefix indicating the type of node.  
  # @param indent [Array<Symbol>] The array of indentation keys.  
  # @return [void]  
  def concant(node, prefix:, indent:)
    prefix_string = { middle: '╠═ ', last: '╚═ ' }[prefix] || ''
    indent_string = indent.map { |i| generate_indent(i) }.join
    @output << "#{indent_string}#{prefix_string}#{node}\n"
  end

  # Processes an array of nodes and concatenates them to the output string.  
  #
  # @param array [Array] The array of nodes to be processed.  
  # @param indent [Array<Symbol>] The array of indentation keys.  
  # @return [void]  
  def process_array(array, indent:)
    array.each_with_index do |item, index|
      prefix = index == array.size - 1 ? :last : :middle
      concant(item, prefix: prefix, indent: indent)
    end
  end

  # Processes a hash of nodes and concatenates them to the output string.  
  #
  # @param hash [Hash] The hash of nodes to be processed.  
  # @param level [Integer] The current level of indentation.  
  # @param indent [Array<Symbol>] The array of indentation keys.  
  # @return [void]  
  def process_hash(hash, level:, indent:)
    hash.each_with_index do |(key, value), index|
      new_indent = indent.dup
      prefix = :empty

      if level > new_indent.size
        prefix = index == hash.size - 1 ? :last : :middle
        new_indent = indent + [prefix]
      end

      concant(key, prefix: prefix, indent: indent)
      process_node(value, indent: new_indent, level: level)
    end
  end

  # Processes a node (hash, array, or other) and concatenates it to the output string.  
  #
  # @param node [Object] The node to be processed.  
  # @param level [Integer] The current level of indentation.  
  # @param indent [Array<Symbol>] The array of indentation keys.  
  # @return [void]
  def process_node(node, level: 0, indent: [''])
    if node.is_a?(Hash)
      process_hash(node, indent: indent, level: level + 1)
    elsif node.is_a?(Array)
      process_array(node, indent: indent)
    elsif !node.nil?
      concant(node, prefix: :last, indent: indent)
    end
  end
end
