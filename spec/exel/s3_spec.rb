module EXEL
  describe S3 do
    it 'sets itself as the remote provider' do
      expect(EXEL.remote_provider).to eq(EXEL::S3::S3Provider)
    end
  end
end
