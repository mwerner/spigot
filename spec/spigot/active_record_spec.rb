require 'spec_helper'

describe Spigot::ActiveRecord do
  let(:subject){ActiveUser.new}
  let(:service){:github}
  let(:data){ {id: '123', full_name: 'Dean Martin'} }

  context '#find_by_api' do
    it 'finds the record' do
      # TODO
      # subject.find_by_api(service, data).should_not be_nil
    end
  end
end
