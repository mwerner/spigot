require 'spec_helper'

describe Spigot::Map::Service do
  let(:klass){ Spigot::Map::Service }
  let(:subject){ klass.new(:github) }

  before{ Spigot::Map::Base.new }

  context '#initialize' do
    it 'assigns a name' do
      subject.name.should eq(:github)
    end

    it 'initializes an empty array of resources' do
      subject.resources.should eq([])
    end
  end

  context '#service' do
    it 'works with a block' do
      Spigot::Map::Service.should_receive(:new).with(:github)

      klass.service(:github){'foo'}
    end

    it 'works without a block' do
      Spigot::Map::Service.should_receive(:new).with(:github)
      expect{
        klass.service(:github)
      }.to_not raise_error(ArgumentError)
    end

    it 'adds the created service to the current map' do
      Spigot.config.map.should_receive(:update)
      klass.service(:github)
    end

    context 'duplicate services' do
      let(:service){Spigot::Map::Service.new(:github)}
      before do
        Spigot.config.map.update(:github, service)
      end

      it 'uses an existing service if already defined' do
        service.should_receive(:instance_eval)
        Spigot.config.map.should_receive(:update).with(:github, service)
        klass.service(:github){'foo'}
      end

      it 'does not duplicate services' do
        klass.service(:github)
        Spigot.config.map.services.length.should eq(1)
      end
    end
  end

  context '.resource' do
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

  context '.reset' do
    it 'resets the resources' do
      subject.resource(:user)
      expect{
        subject.reset
      }.to change{subject.resources.length}.by(-1)
    end
  end

  context '.[]' do
    it 'returns the resource by name' do
      subject.resource(:user)
      user = subject[:user]
      user.should be_a_kind_of(Spigot::Map::Resource)
      user.instance_variable_get(:@name).should eq(:user)
    end
  end

end
