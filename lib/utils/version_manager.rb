# frozen_string_literal: true

# Manages software versions with Major, Minor, and Patch components.
class VersionManager
  attr_reader :major, :minor, :patch

  # Initializes a new instance of VersionManager.
  #
  # @param major [Integer, String] The major version or a string in the format "major.minor.patch".
  # @param minor [Integer] The minor version (optional if major is a string).
  # @param patch [Integer] The patch version (optional if major is a string).
  def initialize(major = 0, minor = 0, patch = 0)
    if major.is_a?(String)
      parse_version_string(major)
    else
      @major = major
      @minor = minor
      @patch = patch
    end
  end

  # Increments the major version and resets minor and patch to 0.
  def increment_major
    @major += 1
    @minor = 0
    @patch = 0
  end

  # Increments the minor version and resets patch to 0.
  def increment_minor
    @minor += 1
    @patch = 0
  end

  # Increments the patch version.
  def increment_patch
    @patch += 1
  end

  # Returns the version as a string in the format "major.minor.patch".
  #
  # @return [String] The formatted version.
  def to_s
    "#{@major}.#{@minor}.#{@patch}"
  end

  private

  # Parses a version string in the format "major.minor.patch".
  #
  # @param version_string [String] The version string.
  def parse_version_string(version_string)
    parts = version_string.split('.')
    @major = parts[0].to_i
    @minor = parts[1].to_i
    @patch = parts[2].to_i
  end
end
