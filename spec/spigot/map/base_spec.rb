require 'spec_helper'

describe Spigot::Map::Base do
  let(:subject){Spigot::Map::Base.new}
  let(:service){Spigot::Map::Service.new(:github)}

  context '#initialize' do
    it 'initializes a services array' do
      subject.services.should eq([])
    end
  end

  context '.define' do
    it 'accepts a block' do
      Spigot::Map::Service.should_receive(:class_eval)
      subject.define{'foo'}
    end

    it 'does not require a block' do
      Spigot::Map::Service.should_not_receive(:class_eval)
      subject.define
    end

    it 'works with one service' do
      subject.define do
        service :github
      end

      subject.services.length.should eq(1)
    end

    it 'allows multiple services' do
      subject.define do
        service :github
        service :twitter
      end

      subject.services.length.should eq(2)
    end

    it 'allows multiple updates' do
      subject.define{ service(:github) }
      subject.define{ service(:twitter) }

      subject.services.length.should eq(2)
    end
  end

  context '.reset' do
    it 'resets services' do
      subject.reset
      subject.services.should eq([])
    end
  end

  context '.service' do
    it 'finds an existing service' do
      subject.update(:github, service)
      subject.service(:github).should eq(service)
    end
  end

  context '.to_hash' do
    it 'returns a hash of current services' do
      subject.update(:github, service)
      subject.to_hash.should eq({github: []})
    end
  end

end
