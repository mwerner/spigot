require 'spec_helper'

describe Spigot::ActiveRecord do
  let(:subject){ActiveUser}
  let(:service){:github}
  let(:data){ Spigot::ApiData.user.merge(id: '987') }

  context 'with invalid mapping' do
    with_mapping(:basic_active_user, Spigot::Mapping::ActiveUser.with_invalid_options)

    context '#find_by_api' do
      it 'requires the primary key to be accurate' do
        expect {
          subject.find_by_api(service, {full_name: 'Dean Martin'}).should_not be_nil
        }.to raise_error(Spigot::InvalidSchemaError)
      end
    end
  end

  context 'with valid mapping' do
    with_mapping(:active_user_with_options, Spigot::Mapping::ActiveUser.with_options)
    let(:user){ subject.create(name: 'Dean Martin', username: 'classyasfuck') }

    context '#find_by_api' do
      before{ user }

      it 'queries by the specified primary_key' do
        subject.find_by_api(service, data).should eq(user)
      end
    end

    context '#find_all_by_api' do
      with_mapping(:non_unique_key, Spigot::Mapping::ActiveUser.non_unique_key)
      before do
        user.update_attribute(:token, '123abc')
        subject.create(name: 'Frank Sinatra', username: 'livetilidie', token: '123abc')
      end

      it 'returns all records matching primary key' do
        subject.find_all_by_api(service, data).length.should eq(2)
      end
    end

    context '#create_by_api' do
      it 'creates a record' do
        record = subject.create_by_api(service, data)
        record.name.should eq('Dean Martin')
        record.username.should eq('classyasfuck')
        record.token.should be_nil
      end
    end

    context '#update_by_api' do
      before{ user }
      it 'updates a record' do
        record = subject.update_by_api(service, data.merge(full_name: 'Dino Baby'))
        record.name.should eq('Dino Baby')
      end
    end

    context '#find_or_create_by_api' do
      before{ user }
      it 'returns an existing record' do
        record = subject.find_or_create_by_api(service, data)
        record.id.should eq(user.id)
      end

      it 'creates a record when none exists' do
        record = subject.find_or_create_by_api(service, Spigot::ApiData.updated_user)
        record.id.should_not eq(user.id)
        record.name.should eq('Frank Sinatra')
        record.username.should eq('livetilidie')
      end
    end

    context '#create_or_update_by_api' do
      before{ user }

      it 'updates an existing record' do
        record = subject.create_or_update_by_api(service, data.merge(full_name: 'Dino Baby'))
        record.id.should eq(user.id)
        record.name.should eq('Dino Baby')
        record.username.should eq('classyasfuck')
      end

      it 'creates a record when none exists' do
        record = subject.create_or_update_by_api(service, Spigot::ApiData.updated_user)
        record.id.should_not eq(user.id)
        record.name.should eq('Frank Sinatra')
        record.username.should eq('livetilidie')
      end
    end
  end

end
