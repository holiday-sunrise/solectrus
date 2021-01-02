describe 'Stats' do
  describe 'GET /' do
    context 'without params' do
      it 'redirects' do
        get stats_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context 'with params' do
      it 'renders', vcr: true do
        get stats_path(timeframe: 'current'), headers: { 'ACCEPT' => 'text/html; turbo-stream, text/html, application/xhtml+xml' }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end