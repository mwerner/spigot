require 'spec_helper'

describe Spigot::Base do
  let(:data){Spigot::Data::User.basic}
  before{ Spigot::Mapping::ActiveUser.stub }

  context '#new_by_api' do
    it 'instantiates a record' do
      Spigot::Record.should_receive(:instantiate)
      ActiveUser.new_by_api(github: data)
    end
  end

  context '#spigot' do
    it 'returns a spigot proxy' do
      ActiveUser.spigot(:github).should be_a_kind_of(Spigot::Proxy)
    end
  end

end
