describe 'Prices' do
  describe 'GET /index' do
    context 'when name is "electricity"' do
      it 'returns http success' do
        get '/settings/prices?name=electricity'
        expect(response).to have_http_status(:success)
      end
    end

    context 'when name is "feed_in"' do
      it 'returns http success' do
        get '/settings/prices?name=feed_in'
        expect(response).to have_http_status(:success)
      end
    end

    context 'when name is not given' do
      it 'returns http redirect' do
        get '/settings/prices'
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end