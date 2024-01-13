# frozen_string_literal: true

require_relative '../../lib/resources/path_helper'

RSpec.describe Resources do
  describe '.library_path' do
    it 'should return the library resources path' do
      expect(Resources.library_path).to eq(__dir__.gsub('spec', 'lib'))
    end
  end

  describe '.custom_path' do
    it 'should return nil when ENV[SCRIPT_CUSTOM_RESOURCES] is not defined' do
      expect(Resources.custom_path).to eq(nil)
    end

    it 'should return the custom path when ENV[SCRIPT_CUSTOM_RESOURCES] is defined' do
      dummy_path = 'My/Fake/Custom/Resource/Test/Path'
      Resources.define(custom_path: dummy_path)
      expect(Resources.custom_path).to eq(dummy_path)
    end
  end
end
