describe VersionInfo::Component, type: :component do
  subject(:component) do
    described_class.new(
      current_version: 'v0.5.0-42-gc0ffee',
      commit_time: Time.current,
      github_url: 'https://github.com/user/repo',
    )
  end

  describe '#latest_version' do
    it 'returns the latest version', vcr: { cassette_name: 'github' } do
      expect(component.latest_version).to eq 'v0.6.1'
    end
  end

  describe '#outdated?' do
    subject { component.outdated? }

    before do
      api = instance_double(GithubApi)
      allow(GithubApi).to receive(:new).and_return(api)
      allow(api).to receive(:latest_release).and_return(
        { 'tag_name' => latest_version },
      )
    end

    context 'when the latest version matches the current version' do
      let(:latest_version) { 'v0.5.0' }

      it { is_expected.to be false }
    end

    context 'when the latest version is newer' do
      let(:latest_version) { 'v9.9.999' }

      it { is_expected.to be true }
    end

    context 'when the latest is older' do
      let(:latest_version) { 'v0.4.0' }

      it { is_expected.to be false }
    end
  end

  describe '#latest_release_url', vcr: { cassette_name: 'github' } do
    subject { component.latest_release_url }

    it do
      is_expected.to eq 'https://github.com/solectrus/solectrus/releases/tag/v0.6.1'
    end
  end
end
