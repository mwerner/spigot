require 'spec_helper'

describe Spigot::Translator do

  context '#initialize' do
    it 'requires a service' do
      expect{
        Spigot::Translator.new(nil, Struct)
      }.to raise_error(Spigot::InvalidServiceError)
    end

    it 'requires a resource' do
      expect{
        Spigot::Translator.new(:github, nil)
      }.to raise_error(Spigot::InvalidResourceError)
    end

    it 'accepts an instance or class resource' do
      by_class    = Spigot::Translator.new(:github, User)
      by_instance = Spigot::Translator.new(:github, User.new)
      expect(by_class.resource).to eq(by_instance.resource)
    end
  end

  # context '#format' do
  #   let(:subject){Spigot::Translator.new(:github, User.new, {a: '1'})}

  #   context 'with a missing resource map' do
  #     it 'raises error with a missing resource map' do
  #       expect{
  #         subject.format
  #       }.to raise_error(Spigot::MissingResourceError)
  #     end
  #   end

  #   context 'with a symbol keyed map' do
  #     let(:subject){Spigot::Translator.new(:github, User.new, Spigot::ApiData.basic_user)}

  #     context 'with a basic mapping' do
  #       before{ use_map(Spigot::Mapping::User.symbolized) }

  #       it 'reads one layer' do
  #         expect(subject.format).to eq({'name' => 'Dean Martin', 'username' => 'classyasfuck'})
  #       end
  #     end
  #   end

  #   context 'and a valid resource map' do
  #     before{ use_map(Spigot::Mapping::User.basic) }

  #     it 'returns empty hash from nil data' do
  #       expect(subject.format).to eq({})
  #     end
  #   end

  #   context 'with basic user data' do
  #     let(:subject){Spigot::Translator.new(:github, User.new, Spigot::ApiData.basic_user)}

  #     context 'with a basic mapping' do
  #       before{ use_map(Spigot::Mapping::User.basic) }

  #       it 'reads one layer' do
  #         expect(subject.format).to eq({'name' => 'Dean Martin', 'username' => 'classyasfuck'})
  #       end
  #     end

  #     context 'with a mapping containing nested data' do
  #       let(:subject){Spigot::Translator.new(:github, User.new, Spigot::ApiData.nested_user)}
  #       before{ use_map(Spigot::Mapping::User.nested) }

  #       it 'traverses into the nested hash' do
  #         expect(subject.format).to eq({
  #           'name' => 'Dean Martin',
  #           'username' => 'classyasfuck',
  #           'contact' => 'dino@amore.io'
  #         })
  #       end

  #       context 'twice' do
  #         before{ use_map(Spigot::Mapping::User.nested_twice) }
  #         let(:subject){Spigot::Translator.new(:github, User.new, Spigot::ApiData.double_nested_user)}

  #         it 'traverses multiple levels' do
  #           expect(subject.format.values).to include(*['Dean Martin','classyasfuck','dino@amore.io'])
  #         end
  #       end
  #     end
  #   end

  #   context 'with an array of values' do
  #     let(:subject){Spigot::Translator.new(:github, User.new, Spigot::ApiData.user_array)}
  #     before{ use_map(Spigot::Mapping::User.basic) }

  #     it 'returns an array of formatted data' do
  #       expect(subject.format.length).to eq(2)
  #       expect(subject.format.map{|u| u['name']}).to include('Dean Martin', 'Frank Sinatra')
  #     end
  #   end

  #   context 'with a nested array of values' do
  #     let(:subject){Spigot::Translator.new(:github, User.new, Spigot::ApiData.nested_user_array)}
  #     before{ use_map(Spigot::Mapping::User.nested_array) }

  #     it 'handles a nested array of values' do
  #       expect(subject.format.keys).to include('name', 'users', 'user_count')
  #       expect(subject.format['users']).to be_a(Array)
  #     end
  #   end

  #   context 'with a namedspaced resource' do
  #     let(:subject){Spigot::Translator.new(:github, Wrapper::Post.new, Spigot::ApiData.post)}
  #     before{ use_map(Spigot::Mapping::Post.namespaced) }

  #     it 'accesses the wrapper/post key' do
  #       expect(subject.format).to eq({'title' => 'Regular Article', 'description' => 'dolor sit amet'})
  #     end
  #   end
  # end

  # context '#lookup' do
  #   let(:subject){Spigot::Translator.new(:github, User.new, {a: '1'})}

  #   it 'returns the value at a given key' do
  #     subject.lookup(:a).should eq('1')
  #   end
  # end

  # context '#id' do
  #   let(:subject){Spigot::Translator.new(:github, User.new, {id: '123'})}

  #   it 'returns the value at the foreign_key' do
  #     subject.stubs(:foreign_key).returns('id')
  #     subject.id.should eq('123')
  #   end
  # end

  # context '#conditions' do
  #   let(:subject){Spigot::Translator.new(:github, User.new, Spigot::ApiData.user)}

  #   context 'without conditions specified' do
  #     before{ use_map(Spigot::Mapping::User.with_options) }
  #     it 'should return a hash' do
  #       subject.conditions.should eq({"username"=>"classyasfuck"})
  #     end
  #   end

  #   context 'with conditions specified' do
  #     use_map Spigot::Mapping::User.with_conditions

  #     it 'can specify the keys used in the map options' do
  #       subject.conditions.should eq({"username"=>"classyasfuck", "name"=>"Dean Martin"})
  #     end

  #     it 'can specify only one key' do
  #       subject.conditions.should eq({"username"=>"classyasfuck", "name"=>"Dean Martin"})
  #     end
  #   end
  # end

  context '#options' do
    let(:subject){Spigot::Translator.new(:github, User.new, {remote_id: '987'})}
    before{ Spigot::Mapping::User.define_basic_map }

    context 'without options provided' do
      context 'defaults' do
        it '#primary_key is the name of the service _id' do
          puts 'Start test'
          puts subject.inspect
          puts Spigot.config.map
          # puts Spigot.config.map
          subject.primary_key.should eq('github_id')
        end

        it '#foreign_key is id' do
          subject.foreign_key.should eq('id')
        end
      end
    end

  #   context 'with options provided' do
  #     use_map(Spigot::Mapping::User.with_options)

  #     it 'reads the options from the spigot key' do
  #       subject.options.should eq(Spigot::Mapping::User.with_options['user']['spigot'])
  #     end

  #     context '#primary_key' do
  #       it 'reads a primary key from the mapping' do
  #         subject.primary_key.should eq('username')
  #       end
  #     end

  #     context '#foreign_key' do
  #       it 'reads a foreign key from the mapping' do
  #         subject.foreign_key.should eq('login')
  #       end
  #     end
  #   end
  end

end
