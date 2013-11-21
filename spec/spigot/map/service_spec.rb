require 'spec_helper'

describe Spigot::Map::Service do
  let(:klass){Spigot::Map::Service}

  context '#initialize' do
    let(:subject){klass.new(:github)}
    it 'assigns a name' do
      subject.name.should eq(:github)
    end

    it 'initializes an empty array of resources' do
      subject.resources.should eq([])
    end
  end

  context '#service' do
    it 'creates a service' do
      Spigot::Map::Service.should_receive(:new).with(:github)
      klass.service(:github){'foo'}
    end

    it 'does not require a block' do
      expect{
        klass.service(:github)
      }.to_not raise_error(ArgumentError)
    end

    it 'adds instantiated service to @@services' do
      expect{
        klass.service(:github)
      }.to change{klass.services.length}.by(1)
    end
  end

  context '#resource' do
    let(:subject){klass.new(:github)}
    it 'builds a resource' do
      Spigot::Map::Resource.should_receive(:new).with(:user)
      subject.resource(:user){'foo'}
    end

    it 'does not require a block' do
      expect{
        subject.resource(:user)
      }.to_not raise_error(ArgumentError)
    end
  end

end
