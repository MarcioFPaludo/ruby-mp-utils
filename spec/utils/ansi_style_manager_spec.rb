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

  # rubocop:disable Layout/LineLength
  describe '#to_s' do
    it 'Converts the string with all tokens replaced by corresponding ANSI codes' do
      manager = ANSIStyleManager.new('<effect:italic><effect:bold> Hello </effect> <color:red>World</color></effect>')
      expect(manager.to_s).to eq("\e[3m\e[1m Hello \e[22m \e[31mWorld\e[49;39m\e[23m")
    end

    it 'applies ANSI styles correctly for the first input' do
      manager = ANSIStyleManager.new('Test <color:blue> color<color:200> <effect:bold>with another color </color> without </effect></color>background!')
      expect(manager.to_s).to eq("Test \e[34m color\e[38;5;200m \e[1mwith another color \e[34m without \e[22m\e[49;39mbackground!")
    end

    it 'applies ANSI styles correctly for the second input' do
      manager = ANSIStyleManager.new('Test <color:1;200;3> color<color:yellow> with another color </color> without </color>background!')
      expect(manager.to_s).to eq("Test \e[38;2;1;200;3m color\e[33m with another color \e[38;2;1;200;3m without \e[49;39mbackground!")
    end

    it 'applies ANSI styles correctly for the third input' do
      manager = ANSIStyleManager.new('Test <color:1;200;3> color<color:200> with another color </color> without </color>background!')
      expect(manager.to_s).to eq("Test \e[38;2;1;200;3m color\e[38;5;200m with another color \e[38;2;1;200;3m without \e[49;39mbackground!")
    end

    it 'applies ANSI styles correctly for the fourth input' do
      manager = ANSIStyleManager.new('Test <color:blue> color<color:200> with another color </color> without </color>background!')
      expect(manager.to_s).to eq("Test \e[34m color\e[38;5;200m with another color \e[34m without \e[49;39mbackground!")
    end

    it 'applies ANSI styles correctly for the fifth input' do
      manager = ANSIStyleManager.new('Test <color:1;200;3:white> color<color:200> with another color </color> with </color>background!')
      expect(manager.to_s).to eq("Test \e[47;38;2;1;200;3m color\e[38;5;200m with another color \e[47;38;2;1;200;3m with \e[49;39mbackground!")
    end

    it 'applies ANSI styles correctly for the sixth input' do
      manager = ANSIStyleManager.new('Test <color:2:white> color<color:5:10> <effect:bold>with another color </color> with </effect></color>background!')
      expect(manager.to_s).to eq("Test \e[47;38;5;2m color\e[48;5;10;38;5;5m \e[1mwith another color \e[47;38;5;2m with \e[22m\e[49;39mbackground!")
    end
  end
  # rubocop:enable Layout/LineLength
end
