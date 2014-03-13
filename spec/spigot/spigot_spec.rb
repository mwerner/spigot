require 'spec_helper'

describe Spigot do
  let(:subject){Spigot}
  context '#resource' do
    it 'defines a resource' do
      Spigot.should_receive(:define)
      subject.resource(:user){'foo'}
    end
  end

  context '#service' do
    it 'defines a service' do
      Spigot.should_receive(:define)
      subject.service(:github){'foo'}
    end

    it 'continues a normal definition' do
      Spigot::Map::Service.any_instance.should_receive(:resource)
      subject.service(:github) do
        resource(:user){ 'foo' }
      end
    end
  end

  context '#logger' do
    it 'produces a logger' do
      Logger.should_receive(:new).with(STDOUT)
      Spigot.logger
    end

    it 'sets level and formatter' do
      Logger.should_receive(:new).and_return(mock(:level= => true, :formatter= => true))
      Spigot.logger
    end
  end
end
