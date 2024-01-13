# frozen_string_literal: true

require_relative '../../lib/utils/message'

RSpec.describe Message do
  describe '.new' do
    it 'should raise error if object is not a Hash' do
      expect {Message.new('', replaces: [])}.to raise_error('Messsage replaces content need be a Hash')
    end
  end


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
      expect(Message.new(value).to_s).to eq('Hellow World from MPUtils!')
    end

    it 'should custom hellow world message' do
      Resources.define(custom_path: Resources.library_path.gsub('lib', 'spec'))
      expect(Message.new('hellow_world').to_s).to eq('Specs Hellow World!')
      Resources.define(custom_path: nil)
      expect(Message.new('hellow_world').to_s).to eq('Hellow World from MPUtils!')
    end

    it 'should replace keys valid keys with resource messages' do
      invalid_key = Key.new('good_by_world')
      valid_key = Key.new('hellow_world')

      result = "hellow_world #{invalid_key} Hellow World from MPUtils!"
      expect(Message.new("hellow_world #{invalid_key} #{valid_key}").to_s).to eq(result)
    end

    it 'should replace keys with given replaces values' do
      replaces = { Key.new('username') => 'Alice', Key.new('code') => 'XYZ123'} 
      message = 'Welcome, <||username||>! Your code is <||code||>.'
      message += "\nWe hope you are well <||username||>!"

      result = "\nWe hope you are well Alice!"
      result = "Welcome, Alice! Your code is XYZ123.#{result}"
      expect(Message.new(message, replaces: replaces).to_s).to eq(result)
    end

    it 'should replace valid keys with resource messages and replace keys with given replaces values' do
      message = "<||hellow_world||>\nWe hope you are well <||username||>!"
      replaces = { '<||username||>' => 'Alice' } 

      result = "Hellow World from MPUtils!\nWe hope you are well Alice!"
      expect(Message.new(message, replaces: replaces).to_s).to eq(result)
    end
  end
end
