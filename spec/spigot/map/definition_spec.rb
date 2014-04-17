require 'spec_helper'

describe Spigot::Map::Definition do
  let(:resource) { Spigot::Map::Resource.new(:user) }

  context '#initialize' do
    it 'assigns variables' do
      subject = Spigot::Map::Definition.new(:foo, 'bar')
      subject.instance_variable_get(:@name).should_not be_nil
      subject.instance_variable_get(:@value).should_not be_nil
    end

    context '#with a block' do
      it 'assigns parse' do
        subject = Spigot::Map::Definition.new(:foo, 'bar') { 'baz' }
        subject.instance_variable_get(:@parse).should_not be_nil
      end
    end
  end

  context '#parse' do
    before do
      Spigot.define do
        resource :active_user do
          name :name
        end
      end
    end

    it 'raises invalid schema if parsing data is not a hash' do
      subject = Spigot::Map::Definition.define(resource, :foo, ActiveUser)
      expect {
        subject.parse(foo: 'b')
      }.to raise_error(Spigot::InvalidSchemaError)
    end

    it 'does not attach the sub resource' do
      subject = Spigot::Map::Definition.define(resource, :foo, ActiveUser)
      subject.parse(foo: { name: 'Dean' }).should eq(active_user: { name: 'Dean' })
      subject.instance_variable_get(:@parse).should be_nil
      subject.instance_variable_get(:@children).length.should eq(0)
    end

    context 'with children' do
      it 'does not attach the sub resource' do
        subject = Spigot::Map::Definition.define(resource, :foo) do
          bar :baz
          qux ActiveUser
        end
        subject.parse({
          foo: {
            bar: 'a', qux: { name: 'Frank' }
          }
        }).should eq(baz: 'a', active_user: { name: 'Frank' })
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
      subject = Spigot::Map::Definition.define(resource, :foo) { |val| "formatted-#{val}" }
      subject.instance_variable_get(:@parse).should_not be_nil
      subject.instance_variable_get(:@children).length.should eq(0)
    end

    it 'requires a attribute param to parse block' do
      subject = Spigot::Map::Definition.define(resource, :foo, 'bar') { |val| "formatted-#{val}" }
      subject.instance_variable_get(:@parse).should_not be_nil
      subject.instance_variable_get(:@children).length.should eq(0)
      subject.parse(foo: 'baz').should eq({bar: 'formatted-baz'})
    end
  end

  context '#to_hash' do
    it 'returns a hash of values' do
      subject = Spigot::Map::Definition.define(resource, :foo) do
        bar :baz
        qux :mjw
      end
      subject.to_hash.should eq(foo: { bar: :baz, qux: :mjw })
    end
  end

end
