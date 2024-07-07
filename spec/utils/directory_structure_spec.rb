# frozen_string_literal: true

require_relative '../../lib/utils/directory_structure'

RSpec.describe DirectoryStructure do
  let(:hash_content) do
    {
      'lib' => {
        'version.rb' => nil,
        'source' => [
          'file_1.rb',
          'file_2.rb',
          'file_3.rb'
        ],
        'resource' =>
      {
        'images' => [
          'potato.png',
          'fries.jpeg',
          'franch_fries.png'
        ],
        'scripts' => {
          validation: 'teste.rb',
          sorting: [
            'shellsort.rb',
            'quicksort.rb'
          ],
          'build.rb' => nil
        }
      },
        generated: 'file.generated.rb'
      }
    }
  end

  let(:yaml_content) do
    File.join(
      __dir__.gsub('utils', 'resources'),
      'test_directory_structure.yml'
    )
  end

  describe '#initialize' do
    context 'when initialized with a hash' do
      it 'does not raise an error' do
        expect { DirectoryStructure.new(hash_content) }.not_to raise_error
      end
    end

    context 'when initialized with a valid YAML file' do
      it 'does not raise an error' do
        expect { DirectoryStructure.new(yaml_content) }.not_to raise_error
      end
    end

    context 'when initialized with an invalid content' do
      it 'raises an error' do
        expect do
          DirectoryStructure.new('invalid_content')
        end.to raise_error(RuntimeError, 'Need be initialized with a Hash or yaml file path')
      end
    end
  end

  describe '#to_s' do
    context 'when initialized with a hash' do
      it 'returns the correct string representation' do
        dir_structure = DirectoryStructure.new(hash_content)
        expected_output = <<~OUTPUT
          lib
          ╠═ version.rb
          ╠═ source
          ║  ╠═ file_1.rb
          ║  ╠═ file_2.rb
          ║  ╚═ file_3.rb
          ╠═ resource
          ║  ╠═ images
          ║  ║  ╠═ potato.png
          ║  ║  ╠═ fries.jpeg
          ║  ║  ╚═ franch_fries.png
          ║  ╚═ scripts
          ║     ╠═ validation
          ║     ║  ╚═ teste.rb
          ║     ╠═ sorting
          ║     ║  ╠═ shellsort.rb
          ║     ║  ╚═ quicksort.rb
          ║     ╚═ build.rb
          ╚═ generated
             ╚═ file.generated.rb
        OUTPUT
        expect(dir_structure.to_s).to eq(expected_output)
      end
    end

    context 'when initialized with a YAML file' do
      it 'returns the correct string representation' do
        dir_structure = DirectoryStructure.new(yaml_content)
        expected_output = <<~OUTPUT
          lib
          ╠═ version.rb
          ╠═ source
          ║  ╠═ file_1.rb
          ║  ╠═ file_2.rb
          ║  ╚═ file_3.rb
          ╠═ resource
          ║  ╠═ images
          ║  ║  ╠═ potato.png
          ║  ║  ╠═ fries.jpeg
          ║  ║  ╚═ franch_fries.png
          ║  ╚═ scripts
          ║     ╠═ validation
          ║     ║  ╚═ teste.rb
          ║     ╠═ sorting
          ║     ║  ╠═ shellsort.rb
          ║     ║  ╚═ quicksort.rb
          ║     ╚═ build.rb
          ╚═ generated
             ╚═ file.generated.rb
        OUTPUT
        expect(dir_structure.to_s).to eq(expected_output)
      end
    end
  end
end
