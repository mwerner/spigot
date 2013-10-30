require 'spec_helper'

describe Spigot::Configuration do
  before do
    @prior_translations = Spigot.config.translations
  end

  after do
    Spigot.configure{|c| c.translations = @prior_translations }
  end

  context 'defaults' do
    it 'is a hash of default configuration' do
      expect(Spigot::Configuration.defaults).to be_kind_of(Hash)
    end
  end

  context 'access' do
    before do
      @previous_path = Spigot.config.path
    end

    after do
      Spigot.configure{|config| config.path = @previous_path }
    end

    it "is callable from .configure" do
      Spigot.configure do |c|
        expect(c).to be_kind_of(Spigot::Configuration)
      end
    end

    it "is able to set the path" do
      Spigot.configure{|config| config.path = '/baller' }
      expect(Spigot.config.path).to eq('/baller')
    end

    it "is able to set translations" do
      Spigot.configure{|config| config.translations = {'user' => {a: 1}} }
      expect(Spigot.config.translations).to eq({'user' => {a: 1}})
    end
  end
end
