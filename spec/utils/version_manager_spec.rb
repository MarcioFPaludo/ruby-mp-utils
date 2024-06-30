# frozen_string_literal: true

require_relative '../../lib/utils/version_manager'

RSpec.describe VersionManager do
  describe '#initialize' do
    context 'when initialized with integers' do
      it 'sets the major, minor, and patch versions' do
        version = VersionManager.new(1, 2, 3)
        expect(version.major).to eq(1)
        expect(version.minor).to eq(2)
        expect(version.patch).to eq(3)
      end
    end

    context 'when initialized with a version string' do
      it 'parses the version string and sets the major, minor, and patch versions' do
        version = VersionManager.new('3.4.5')
        expect(version.major).to eq(3)
        expect(version.minor).to eq(4)
        expect(version.patch).to eq(5)
      end
    end
  end

  describe '#increment_major' do
    it 'increments the major version and resets minor and patch to 0' do
      version = VersionManager.new(1, 2, 3)
      version.increment_major
      expect(version.major).to eq(2)
      expect(version.minor).to eq(0)
      expect(version.patch).to eq(0)
    end
  end

  describe '#increment_minor' do
    it 'increments the minor version and resets patch to 0' do
      version = VersionManager.new(1, 2, 3)
      version.increment_minor
      expect(version.major).to eq(1)
      expect(version.minor).to eq(3)
      expect(version.patch).to eq(0)
    end
  end

  describe '#increment_patch' do
    it 'increments the patch version' do
      version = VersionManager.new(1, 2, 3)
      version.increment_patch
      expect(version.major).to eq(1)
      expect(version.minor).to eq(2)
      expect(version.patch).to eq(4)
    end
  end

  describe '#to_s' do
    it 'returns the version as a string in the format "major.minor.patch"' do
      version = VersionManager.new(1, 2, 3)
      expect(version.to_s).to eq('1.2.3')
    end
  end
end
