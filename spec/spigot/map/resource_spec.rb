require 'spec_helper'

describe Spigot::Map::Resource do
  let(:subject){Spigot::Map::Resource.new(:user){ username :login }}

  context '#initialize' do
    it 'assigns a name' do
      subject.instance_variable_get(:@name).should eq(:user)
    end

    it 'does not require a block' do
      expect{
        Spigot::Map::Resource.new(:user)
      }.to_not raise_error(ArgumentError)
    end

    it 'builds definitions included in block' do
      Spigot::Map::Resource.any_instance.should_receive(:define).with(:username, :login)
      subject #=> Evaluate the let statement
    end
  end

  context '.define' do
    it 'builds a definition' do
      subject.send(:define, :name, 'username')
      subject.instance_variable_get(:@definitions).length.should eq(2)
    end
  end

  context '#method_missing' do
    before{ subject.should_receive(:define).with(:username, :login) }
    it 'builds a definition for missing methods' do
      subject.username :login
    end

    it 'allows for assignment' do
      subject.username = :login
    end
  end

  context '.options' do
    let(:subject){Spigot::Map::Resource.new(:user){ options{ primary_key :foo } }}

    it 'sets the options' do
      options = subject.instance_variable_get(:@options)
      options.primary_key.should eq(:foo)
    end
  end

  context '.to_hash' do
    it 'returns a hash of resources' do
      subject.to_hash.should be_a_kind_of(Hash)
    end

    it 'returns the resource values' do
      subject.to_hash[:username].should eq(:login)
    end
  end

end
