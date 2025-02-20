RSpec.describe Api::V0::ArticlesController, type: :request do
  let(:headers) { {HTTP_ACCEPT: "application/json"} }

  describe 'GET /v0/articles' do
    before do
      5.times { FactoryBot.create(:article) }
      get '/api/v0/articles', headers: headers
    end


    it 'should return collection of articles' do    
      expect(response_json.count). to eq 5
    end

    it 'returns 200 response' do
      expect(response.status).to eq 200
    end

  end
end

