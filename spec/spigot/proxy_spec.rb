require 'spec_helper'

describe Spigot::Proxy do

  context '#initialize' do
    let(:subject) { Spigot::Proxy }
    it 'accepts a service and a resource' do
      proxy = subject.new(User, :github)
      proxy.resource.should eq(User)
      proxy.service.should eq(:github)
    end

    it 'does not require a service' do
      expect {
        subject.new(User)
      }.to_not raise_error
    end
  end

  context 'Active Record aliases' do
    let(:subject) { Spigot::Proxy.new(ActiveUser) }
    it 'aliases find' do
      ActiveUser.should_receive(:find_by_api)
      subject.find(a: 1)
    end

    it 'aliases find_all' do
      ActiveUser.should_receive(:find_all_by_api)
      subject.find_all(a: 1)
    end

    it 'aliases create' do
      ActiveUser.should_receive(:create_by_api)
      subject.create(a: 1)
    end

    it 'aliases update' do
      ActiveUser.should_receive(:update_by_api)
      subject.update(a: 1)
    end

    it 'aliases find_or_create' do
      ActiveUser.should_receive(:find_or_create_by_api)
      subject.find_or_create(a: 1)
    end

    it 'aliases create_or_update' do
      ActiveUser.should_receive(:create_or_update_by_api)
      subject.create_or_update(a: 1)
    end

    context 'with a specified service' do
      let(:subject) { Spigot::Proxy.new(ActiveUser, :github) }
      before { Spigot::Mapping::ActiveUser.stub }
      it 'uses the current service' do
        ActiveUser.should_receive(:create_by_api).with(github: { a: 1 })
        subject.create(a: 1)
      end

      it 'checks for conflicting services' do
        Spigot::Mapping::ActiveUser.twitter
        expect {
          subject.create(twitter: { a: 1 })
        }.to raise_error(Spigot::InvalidServiceError)
      end

      it 'only scopes by one service if both are defined' do
        ActiveUser.should_receive(:create_by_api).with(github: { a: 1 })
        subject.create(github: { a: 1 })
      end
    end
  end

  context 'instance methods' do
    let(:subject) { Spigot::Proxy.new(User, :github) }

    context '.translator' do
      it 'returns a translator object' do
        Spigot::Translator.should_receive(:new).with(User, :github)
        subject.translator
      end
    end

    context '.map' do
      it 'returns the currently defined map' do
        Spigot::Translator.any_instance.should_receive(:resource_map)
        subject.map
      end
    end

    context '.options' do
      it 'returns the current options' do
        Spigot::Translator.any_instance.should_receive(:options)
        subject.options
      end
    end
  end

end
