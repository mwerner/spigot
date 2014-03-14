require 'spec_helper'

describe Spigot::Translator do
  context '#initialize' do
    before { Spigot::Mapping::User.basic }
    it 'does not require a service' do
      expect {
        Spigot::Translator.new(Struct, nil)
      }.to_not raise_error(Spigot::InvalidServiceError)
    end

    it 'requires a resource' do
      expect {
        Spigot::Translator.new(nil, :github)
      }.to raise_error(Spigot::InvalidResourceError)
    end

    it 'accepts an instance or class resource' do
      by_class    = Spigot::Translator.new(User)
      by_instance = Spigot::Translator.new(User.new)
      expect(by_class.resource).to eq(by_instance.resource)
    end
  end

  context '.format' do
    context 'with a missing resource map' do
      let(:subject) { Spigot::Translator.new(User.new, :github, Spigot::Data::User.basic) }
      it 'raises error with a missing resource map' do
        expect {
          subject.format
        }.to raise_error(Spigot::MissingResourceError)
      end
    end

    context 'with a valid resource map' do
      context 'with a simple map' do
        let(:data) { Spigot::Data::User.basic }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        before { Spigot::Mapping::User.basic }
        it 'returns empty hash from nil data' do
          subject.data = {}
          expect(subject.format).to eq(name: nil, username: nil)
        end

        it 'reads one layer' do
          expect(subject.format).to eq(name: 'Dean Martin', username: 'classyasfuck')
        end
      end

      context 'with a nested map' do
        let(:data) { Spigot::Data::User.nested }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        before { Spigot::Mapping::User.nested }

        it 'traverses into the nested hash' do
          expect(subject.format).to eq({
            name: 'Dean Martin',
            username: 'classyasfuck',
            contact: 'dino@amore.io'
          })
        end
      end

      context 'nested twice' do
        let(:data) { Spigot::Data::User.double_nested }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        before { Spigot::Mapping::User.nested_twice }

        it 'traverses multiple levels' do
          expect(subject.format).to eq({
            name: 'Dean Martin',
            ip: '127.0.0.1',
            username: 'classyasfuck',
            contact: 'dino@amore.io'
          })
        end
      end

      context 'with an array of values' do
        let(:data) { Spigot::Data::User.array }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        before { Spigot::Mapping::User.basic }

        it 'returns an array of formatted data' do
          subject.format.should eq([
            { name: 'Dean Martin', username: 'classyasfuck' },
            { name: 'Frank Sinatra', username: 'livetilidie' }
          ])
        end
      end

      context 'with a nested array of values' do
        let(:data) { Spigot::Data::User.nested_array }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        before { Spigot::Mapping::User.nested_array }

        it 'handles a nested array of values' do
          subject.format.should eq({
            name: 'Rockafella',
            user_count: 2,
            users: [
              { name: 'Dean Martin', username: 'classyasfuck' },
              { name: 'Frank Sinatra', username: 'livetilidie' }
            ]
          })
        end
      end

      context 'with a namedspaced resource' do
        let(:data) { Spigot::Data::Post.basic }
        let(:subject) { Spigot::Translator.new(Wrapper::Post.new, :github, data) }
        before { Spigot::Mapping::Post.basic }

        it 'accesses the wrapper/post key' do
          subject.format.should eq({
            title: 'Brief Article',
            description: 'lorem ipsum'
          })
        end
      end

      context 'with an interpolated value' do
        let(:data) { Spigot::Data::User.basic }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        before { Spigot::Mapping::User.interpolated }
        it 'reads one layer' do
          expect(subject.format).to eq(name: 'Dean Martin', username: '@classyasfuck')
        end
      end

      context 'with a nested interpolated value' do
        let(:data) { Spigot::Data::User.nested }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        before { Spigot::Mapping::User.nested_interpolation }
        it 'reads one layer' do
          result = { name: 'Dean Martin', contact: 'dino@amore.io', username: '@classyasfuck' }
          expect(subject.format).to eq(result)
        end
      end

      context 'without a service' do
        let(:data) { Spigot::Data::User.basic }
        let(:subject) { Spigot::Translator.new(User.new, nil, data) }
        before { Spigot::Mapping::User.serviceless }
        it 'reads one layer' do
          expect(subject.format).to eq(name: 'Dean Martin', username: 'classyasfuck')
        end

        it 'does not use the any definition with an invalid service' do
          subject = Spigot::Translator.new(User.new, :github, data)
          expect {
            subject.format
          }.to raise_error(Spigot::InvalidServiceError)
        end
      end

      context 'multiple resources without a service' do
        before { Spigot::Mapping::User.multiple_serviceless }
        it 'reads one layer' do
          user = Spigot::Translator.new(User.new, nil, Spigot::Data::User.basic)
          post = Spigot::Translator.new(Post.new, nil, Spigot::Data::Post.basic)

          expect(user.format).to eq(name: 'Dean Martin', username: 'classyasfuck')
          expect(post.format).to eq(headline: 'Brief Article', body: 'lorem ipsum')
        end
      end

      context 'with and without service' do
        before { Spigot::Mapping::User.service_and_serviceless }
        it 'prefers the service definition' do
          service = Spigot::Translator.new(User.new, :github, Spigot::Data::User.basic)
          no_service = Spigot::Translator.new(User.new, nil, Spigot::Data::User.basic)

          expect(service.format).to eq(name: 'classyasfuck', username: 'Dean Martin')
          expect(no_service.format).to eq(name: 'Dean Martin', username: 'classyasfuck')
        end
      end

      context 'with an abridged definition' do
        let(:data) { Spigot::Data::User.basic }
        let(:subject) { Spigot::Translator.new(User.new, nil, data) }
        before { Spigot::Mapping::User.abridged }
        it 'reads one layer' do
          expect(subject.format).to eq(name: 'Dean Martin', username: 'classyasfuck')
        end
      end
    end
  end

  context '#conditions' do
    let(:data) { Spigot::Data::User.basic }
    let(:subject) { Spigot::Translator.new(User.new, :github, data) }

    context 'without conditions specified' do
      before { Spigot::Mapping::User.basic }
      it 'should return a hash' do
        subject.conditions.should eq('github_id' => nil)
      end
    end

    context 'with conditions specified' do
      before { Spigot::Mapping::User.with_conditions }
      it 'can specify the keys used in the map options' do
        subject.conditions.should eq(username: 'classyasfuck')
      end

      it 'can specify only one key' do
        subject.conditions.should eq(username: 'classyasfuck')
      end

      context 'with an array of data' do
        let(:data) { Spigot::Data::User.array }
        let(:subject) { Spigot::Translator.new(User.new, :github, data) }
        it 'can specify an array of values' do
          subject.conditions.should eq(username: %w(classyasfuck livetilidie))
        end
      end
    end
  end

  context '#options' do
    let(:subject) { Spigot::Translator.new(User.new, :github, remote_id: '987') }

    context 'without options provided' do
      before { Spigot::Mapping::User.basic }
      it '#primary_key is the name of the service_id' do
        subject.primary_key.should eq('github_id')
      end
    end

    context 'with options provided' do
      before { Spigot::Mapping::User.with_options }
      it 'reads a primary key from the mapping' do
        subject.primary_key.should eq(:username)
      end

      it 'reads options' do
        subject.options.should be_a_kind_of(Spigot::Map::Option)
      end
    end
  end

  context '#resource_map' do
    let(:subject) { Spigot::Translator.new(User.new) }
    context 'without a service' do
      before { Spigot::Mapping::User.basic }
      it 'raises a missing resource error' do
        expect {
          subject.resource_map
        }.to raise_error(Spigot::MissingResourceError)
      end
    end
  end
end
