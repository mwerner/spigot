require 'spec_helper'

describe Spigot::Configuration do
  context 'defaults' do
    it 'is a hash of default configuration' do
      expect(Spigot::Configuration.defaults).to be_kind_of(Hash)
    end
  end

  context 'access' do
    it 'is callable from .configure' do
      Spigot.configure do |c|
        expect(c).to be_kind_of(Spigot::Configuration)
      end
    end

    context 'options' do
      let(:map) { { 'user' => { a: 1 } } }
      let(:options_key) { 'my_special_key' }

      it 'is able to set the options_key' do
        Spigot.configure { |config| config.options_key = options_key }
        expect(Spigot.config.options_key).to eq(options_key)
      end

      it 'is able to set the logger' do
        logger = Logger.new(STDOUT)
        Spigot.configure { |config| config.logger = logger }
        expect(Spigot.config.logger).to eq(logger)
      end
    end
  end
end
