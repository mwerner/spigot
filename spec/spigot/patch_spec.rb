require 'spec_helper'

describe String do

  context '#underscore' do
    let(:subject) { 'FooBar' }
    it 'converts to underscore' do
      subject.underscore.should eq('foo_bar')
    end
  end

end
