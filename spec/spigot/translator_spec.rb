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

  context '#format' do
    let(:subject){Spigot::Translator.new(:github, User.new)}

    context 'with a missing map' do
      it 'raises error with a missing file' do
        expect {
          subject.format({})
        }.to raise_error(Spigot::MissingServiceError)
      end
    end

    context 'with a missing resource map' do
      before do
        subject.stubs(:translation_file).returns("missing:\n  foo: 'bar'")
      end

      it 'raises error with a missing resource map' do
        expect{
          subject.format({})
        }.to raise_error(Spigot::MissingResourceError)
      end
    end

    context 'and a valid resource map' do
      before do
        subject.stubs(:translations).returns(Spigot::Mapping.basic_user)
      end

      it 'returns nil from nil data' do
        expect(subject.format(nil)).to eq(nil)
      end

      it 'returns nil from anything other than a hash' do
        expect(subject.format(:data)).to eq(nil)
      end
    end

    context 'with basic user data' do
      let(:data){ Spigot::ApiData.basic_user }

      context 'with a basic mapping' do
        before do
          subject.stubs(:translations).returns(Spigot::Mapping.basic_user)
        end

        it 'follows one layer' do
          expect(subject.format(data)).to eq({name: 'Dean Martin', username: 'classyasfuck'})
        end
      end

      context 'with a mapping containing several resources' do
        before do
          subject.stubs(:translations).returns(Spigot::Mapping.multiple_resources)
        end

        it 'selects the user map' do
          expect(subject.format(data)).to eq({name: 'Dean Martin', username: 'classyasfuck'})
        end
      end
    end

    context 'with a namedspaced resource' do
      let(:data){ Spigot::ApiData.post }
      let(:subject){Spigot::Translator.new(:github, Wrapper::Post.new)}
      before do
        subject.stubs(:translations).returns(Spigot::Mapping.namespaced_post)
      end

      it 'accesses the wrapper/post key' do
        expect(subject.format(data)).to eq({title: 'Regular Article', description: 'dolor sit amet'})
      end
    end
  end

end
