require 'spec_helper'

describe Spigot::Record do
  let(:resource){User}
  let(:data){ { a: 1 } }
  let(:subject){ Spigot::Record.new(resource, data) }

  context '#instantiate' do
    it 'exectutes instantiate on an instance' do
      Spigot::Record.any_instance.should_receive(:instantiate)
      Spigot::Record.instantiate(resource, data)
    end
  end

  context '.instantiate' do
    it 'sends a new statement to the resource' do
      resource.should_receive(:new).with(data)
      subject.instantiate
    end
  end

end
