# frozen_string_literal: true

require_relative '../../lib/utils/ansi_style_manager'
require_relative '../../lib/utils/constants'
require_relative '../../lib/utils/ansi'

RSpec.describe ANSIStyleManager do
  describe '#initialize' do
    it 'initializes with a string' do
      manager = ANSIStyleManager.new('Hello World')
      expect(manager.string).to eq('Hello World')
    end

    it 'raises an error if initialized with a non-string' do
      expect { ANSIStyleManager.new(123) }.to raise_error('Need initialize with a string')
    end
  end

  describe '#replace_all_tokens!' do
    it 'replaces all color and effect tokens in the string' do
      manager = ANSIStyleManager.new('Hello <color:red>World</color>')
      manager.replace_all_tokens!
      expect(manager.string).to eq("Hello \e[31mWorld\e[49;39m")
    end
  end

  describe '#replace_color_tokens!' do
    it 'replaces color tokens in the string' do
      manager = ANSIStyleManager.new('Hello <color:red>World</color>')
      manager.replace_color_tokens!
      expect(manager.string).to eq("Hello \e[31mWorld\e[49;39m")
    end
  end

  describe '#replace_effect_tokens!' do
    it 'replaces effect tokens in the string' do
      manager = ANSIStyleManager.new('Hello <effect:bold>World</effect>')
      manager.replace_effect_tokens!
      expect(manager.string).to eq("Hello \e[1mWorld\e[22m")
    end
  end

  describe '#color_prefix' do
    it 'generates the ANSI prefix for a given color and background' do
      manager = ANSIStyleManager.new('')
      prefix = manager.send(:color_prefix, color: 'red', background: 'blue')
      expect(prefix.to_s).to eq("\e[44;31m")
    end
  end

  describe '#generate_color_ansi' do
    it 'generates the ANSI instance for a given color' do
      manager = ANSIStyleManager.new('')
      ansi = manager.send(:generate_color_ansi, 'red', is_background: false)
      expect(ansi.to_s).to eq("\e[31m")
    end

    it 'generates the ANSI instance for a reset color' do
      manager = ANSIStyleManager.new('')
      ansi = manager.send(:generate_color_ansi, 'reset', is_background: false)
      expect(ansi.to_s).to eq("\e[39m")
    end
  end

  describe '#replace_tokens_with!' do
    it 'replaces tokens in the string with corresponding ANSI codes' do
      manager = ANSIStyleManager.new('Hello <color:red>World</color>')
      manager.send(
        :replace_tokens_with!,
        text: 'World',
        to_replace: '<color:red>World</color>',

        ansi_token: ANSI.new(:red),
        ansi_reset_token: ANSI.new(:reset_color),
        preserve_reset_token: false
      )
      expect(manager.string).to eq("Hello \e[31mWorld\e[39m")
    end
  end

  describe '#to_s' do
    it 'converts the string with all tokens replaced by corresponding ANSI codes' do
      manager = ANSIStyleManager.new('Hello <color:red>World</color>')
      expect(manager.to_s).to eq("Hello \e[31mWorld\e[49;39m")
    end
  end
end
