require 'spec_helper'

describe Spigot::Map::Resource do

  context '#initialize' do
    let(:subject){Spigot::Map::Resource.new(:user){ username :login }}
    it 'assigns a name' do
      subject.instance_variable_get(:@name).should eq(:user)
    end

    it 'does not require a block' do
      expect{
        Spigot::Map::Resource.new(:user)
      }.to_not raise_error
    end

    it 'builds definitions included in block' do
      Spigot::Map::Resource.any_instance.should_receive(:define).with(:username, :login)
      subject #=> Evaluate the let statement
    end
  end

  context '#define' do
    let(:subject){ Spigot::Map::Resource.new(:user) }
    it 'builds a definition' do
      subject.send(:define, :name, 'username')
      subject.instance_variable_get(:@definitions).length.should eq(1)
    end
  end

  context '#method_missing' do
    let(:subject){ Spigot::Map::Resource.new(:user) }
    it 'builds a definition for missing methods' do
      subject.username :login
      subject.instance_variable_get(:@definitions).length.should eq(1)
    end

    it 'allows for assignment' do
      subject.should_receive(:define).with(:username, :login)
      subject.username = :login
    end
  end

end
