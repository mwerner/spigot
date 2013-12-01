require 'spec_helper'

describe Spigot::Map::Definition do
  let(:resource){Spigot::Map::Resource.new(:user)}

  context '#initialize' do
    it 'assigns variables' do
      subject = Spigot::Map::Definition.new(:foo, 'bar')
      subject.instance_variable_get(:@name).should_not be_nil
      subject.instance_variable_get(:@value).should_not be_nil
    end

    context '#with a block' do
      it 'assigns parse' do
        subject = Spigot::Map::Definition.new(:foo, 'bar'){'baz'}
        subject.instance_variable_get(:@parse).should_not be_nil
      end
    end
  end

  context '#define' do

    it 'returns a definition with the given key and value' do
      subject = Spigot::Map::Definition.define(resource, :foo, 'bar')
      subject.instance_variable_get(:@name).should eq(:foo)
      subject.instance_variable_get(:@value).should eq('bar')
    end

    it 'accepts a block of definitions' do
      subject = Spigot::Map::Definition.define(resource, :foo) do
        bar :baz
        qux :mjw
      end
      subject.instance_variable_get(:@parse).should be_nil
      subject.instance_variable_get(:@children).length.should eq(2)
    end

    it 'assigns a parse block' do
      subject = Spigot::Map::Definition.define(resource, :foo){|val| "formatted-#{val}" }
      subject.instance_variable_get(:@parse).should_not be_nil
      subject.instance_variable_get(:@children).length.should eq(0)
    end
  end

end
