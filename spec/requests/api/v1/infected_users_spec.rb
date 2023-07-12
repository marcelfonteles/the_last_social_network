require 'rails_helper'

RSpec.describe "Api::V1::InfectedUsers", type: :request do
  describe "PUT /api/v1/users/:id/infected" do
    context 'when success' do
      context 'when user has less than 2 warnings' do
        let(:user) { create(:user) }

        before do
          put("/api/v1/users/#{user.id}/infected")
        end

        subject(:res) { JSON.parse(response.body).deep_symbolize_keys }

        it 'should return status 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'should update the warning count' do
          expect(res[:warning_count]).to eq(1)
        end

        it 'should NOT marked as infected' do
          expect(res[:infected]).to eq(false)
        end
      end

      context 'when user has 2 warnings' do
        let(:user) { create(:user, warning_count: 2) }

        before do
          put("/api/v1/users/#{user.id}/infected")
        end

        subject(:res) { JSON.parse(response.body).deep_symbolize_keys }

        it 'should return status 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'should update the warning count' do
          expect(res[:warning_count]).to eq(3)
        end

        it 'should NOT marked as infected' do
          expect(res[:infected]).to eq(true)
        end
      end

      context 'when user has more than 3 warnings' do
        let(:user) { create(:user, warning_count: 4) }

        before do
          put("/api/v1/users/#{user.id}/infected")
        end

        subject(:res) { JSON.parse(response.body).deep_symbolize_keys }

        it 'should return status 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'should update the warning count' do
          expect(res[:warning_count]).to eq(5)
        end

        it 'should NOT marked as infected' do
          expect(res[:infected]).to eq(true)
        end
      end
    end
  end
end
