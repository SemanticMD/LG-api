require 'rails_helper'
RSpec.describe SessionsController, :type => :controller do
  describe '#create' do
    let!(:user) { Fabricate :user }
    let(:params) { {
      user: credentials
    } }
    let(:request) { ->{ post :create, params } }

    before {
     @request.env["devise.mapping"] = Devise.mappings[:user]
     request.call
    }

    subject { response }

    context 'valid credentials' do
      let(:credentials) { {
        email: user.email,
        password: user.password
      } }
      let(:json) { JSON.parse(response.body) }

      it { expect(response.code).to eq("201") }
      it { expect(json['token']).to be_present }
      it { expect(json['email']).to eq(user.email) }
      it { expect(json['user']).to eq(user.id) }
    end

    context 'invalid credentials' do
      context 'wrong email' do
        let(:credentials) { {
          email: 'unknown',
          password: user.password
        } }

        it { expect(response.code).to eq("401") }
      end

      context 'wrong password' do
        let(:credentials) { {
          email: user.email,
          password: 'bad-password'
        } }

        it { expect(response.code).to eq("401") }
      end

    end
  end
end
