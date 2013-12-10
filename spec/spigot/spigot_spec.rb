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
  end
end
