require 'spec_helper'

describe Spigot::ActiveRecord do
  let(:subject) { ActiveUser }
  let(:data) { Spigot::Data::ActiveUser.basic.merge(id: '987') }
  let(:user) { subject.create(name: 'Dean Martin', username: 'classyasfuck') }

  context 'with invalid mapping' do
    it 'requires the primary key to be accurate' do
      expect {
        subject.find_by_api(full_name: 'Dean Martin')
      }.to raise_error(Spigot::MissingResourceError)
    end

    it 'requires valid primary_keys' do
      Spigot::Mapping::ActiveUser.invalid_primary_key
      expect {
        subject.find_by_api(github: { full_name: 'Dean Martin' })
      }.to raise_error(Spigot::InvalidSchemaError)
    end
  end

  context 'with valid mapping' do
    context '#find_by_api' do
      before do
        user
        Spigot::Mapping::ActiveUser.with_options
      end

      it 'queries by the specified primary_key' do
        subject.find_by_api(github: data).should eq(user)
      end
    end

    context '#find_all_by_api' do
      before do
        Spigot::Mapping::ActiveUser.non_unique_keys
        user.update_attribute(:token, '123abc')
        subject.create(name: 'Frank Sinatra', username: 'livetilidie', token: '123abc')
      end

      it 'returns all records matching primary key' do
        subject.find_all_by_api(github: data).length.should eq(2)
      end
    end

    context '#create_by_api' do
      before { Spigot::Mapping::ActiveUser.with_options }
      it 'creates a record' do
        record = subject.create_by_api(github: data)
        record.id.should_not be_nil
        record.name.should eq('Dean Martin')
        record.username.should eq('classyasfuck')
        record.token.should be_nil
      end
    end

    context '#update_by_api' do
      before do
        user
        Spigot::Mapping::ActiveUser.with_options
      end

      it 'updates a record' do
        record = subject.update_by_api(github: data.merge(full_name: 'Dino Baby'))
        record.name.should eq('Dino Baby')
      end
    end

    context '#find_or_create_by_api' do
      before do
        user
        Spigot::Mapping::ActiveUser.with_options
      end
      it 'returns an existing record' do
        record = subject.find_or_create_by_api(github: data)
        record.id.should eq(user.id)
      end

      it 'creates a record when none exists' do
        record = subject.find_or_create_by_api(github: Spigot::Data::ActiveUser.alt)
        record.id.should_not eq(user.id)
        record.name.should eq('Frank Sinatra')
        record.username.should eq('livetilidie')
      end
    end

    context '#create_or_update_by_api' do
      before do
        user
        Spigot::Mapping::ActiveUser.with_options
      end

      it 'updates an existing record' do
        record = subject.create_or_update_by_api(github: data.merge(full_name: 'Dino Baby'))
        record.id.should eq(user.id)
        record.name.should eq('Dino Baby')
        record.username.should eq('classyasfuck')
      end

      it 'creates a record when none exists' do
        record = subject.create_or_update_by_api(github: Spigot::Data::ActiveUser.alt)
        record.id.should_not eq(user.id)
        record.name.should eq('Frank Sinatra')
        record.username.should eq('livetilidie')
      end
    end
  end

end
