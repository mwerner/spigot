require 'spec_helper'

describe Spigot::Record do
  let(:resource) { ActiveUser }
  let(:data) { { username: 'dino', name: 'Dean Martin' } }
  let(:subject) { Spigot::Record.new(:github, resource, data) }

  context '#instantiate' do
    it 'exectutes instantiate on an instance' do
      Spigot::Record.any_instance.should_receive(:instantiate)
      Spigot::Record.instantiate(:github, resource, data)
    end
  end

  context '.instantiate' do
    it 'sends a new statement to the resource' do
      resource.should_receive(:new).with(data)
      subject.instantiate
    end
  end

  context '#create' do
    it 'handles an array of values' do
      Spigot::Mapping::ActiveUser.stub
      expect {
        Spigot::Record.create(:github, resource, [data, data, data])
      }.to change { ActiveUser.count }.by(3)
    end

    context 'with associations' do
      before do
        Spigot.define do
          service :github do
            resource :event do
              id   :github_id
              type :name
              author ActiveUser
            end
          end
        end
      end

      it 'handles an association' do
        expect {
          Spigot::Record.create(:github, Event, github_id: 123, name: 'Push', active_user: data)
        }.to change { ActiveUser.count }.by(1)
      end

      it 'handles an array of associations' do
        values = [
          { github_id: 123, name: 'Push', active_user: data },
          { github_id: 456, name: 'Comment', active_user: data },
          { github_id: 789, name: 'Commit', active_user: data }]

        expect {
          Spigot::Record.create(:github, Event, values)
        }.to change { ActiveUser.count }.by(3)
      end

      it 'handles nested associations' do
        Spigot.config.reset
        Spigot.define do
          service :github do
            resource :profile do
              image image_url
            end

            resource :active_user do
              full_name :name
              login :username
              profile Profile
            end

            resource :event do
              id   :github_id
              type :name
              author ActiveUser
            end
          end
        end

        user_data = { username: 'dino', name: 'Dean Martin', profile: { image_url: 'abc' } }
        event_data = { github_id: 123, name: 'Push', active_user: user_data }
        expect {
          Spigot::Record.create(:github, Event, event_data)
        }.to change { Profile.count }.by(1)

        Profile.last.image_url.should eq('abc')
      end
    end
  end

end
