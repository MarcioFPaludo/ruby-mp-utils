# frozen_string_literal: true

require_relative '../../lib/utils/message'

RSpec.describe Message do
  describe '.equals' do
    it 'instances with same message should be equal' do
      value = 'Minha mensagem para testes'
      expect(Message.new(value)).to eq(Message.new(value))
    end
  end

  describe '.to_s' do
    it 'should return the same massage passed in instance' do
      value = 'Minha mensagem para testes'
      expect(Message.new(value).to_s).to eq(value)
    end

    it 'should show library hellow world message' do
      value = 'hellow_world'
      expect(Message.new(value).to_s).to eq('Hellow World!')
    end

    it 'should custom hellow world message' do
      Resources.define(custom_path: Resources.library_path.gsub('lib', 'spec'))
      expect(Message.new('hellow_world').to_s).to eq('Specs Hellow World!')
      Resources.define(custom_path: nil)
      expect(Message.new('hellow_world').to_s).to eq('Hellow World!')
    end

    it 'should replace keys valid keys with resource messages' do
      invalid_key = Key.new('good_by_world')
      valid_key = Key.new('hellow_world')

      result = "hellow_world #{invalid_key.value} Hellow World!"
      expect(Message.new("hellow_world #{invalid_key} #{valid_key}").to_s).to eq(result)
    end
  end
end
