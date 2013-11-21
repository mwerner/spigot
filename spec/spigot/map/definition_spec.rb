require 'spec_helper'

describe Spigot::Map::Definition do

  context '#initialize' do
    let(:subject){Spigot::Map::Definition.new(:foo, 'bar')}
    it 'assigns variables' do
      subject.instance_variable_get(:@name).should_not be_nil
      subject.instance_variable_get(:@value).should_not be_nil
    end

    context '#with a block' do
      let(:subject){ Spigot::Map::Definition.new(:foo, 'bar'){'baz'} }
      it 'assigns parse' do
        subject.instance_variable_get(:@parse).should_not be_nil
      end
    end
  end

end
