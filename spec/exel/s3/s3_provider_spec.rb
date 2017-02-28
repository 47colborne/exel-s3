module EXEL
  module S3
    describe S3Provider do
      before :all do
        EXEL.configure do |config|
          config.aws = OpenStruct.new
          config.s3_bucket = 'bucket'
          config.s3_region = 's3-region'
        end
      end

      describe '#get_object' do
        it 'has the correct bucket and file names' do
          file_name = 'abc.txt'
          s3_obj = subject.get_object(file_name)
          expect(s3_obj.bucket_name).to eq('bucket')
          expect(s3_obj.key).to eq(file_name)
        end

        it 'uses the configured s3 region' do
          expect(Aws::S3::Resource).to receive(:new).with(hash_including(region: 's3-region')).and_call_original
          subject.get_object('foo.txt')
        end

        it 'defaults the s3 region to us-east-1' do
          allow(EXEL.configuration).to receive(:s3_region).and_return(nil)
          expect(Aws::S3::Resource).to receive(:new).with(hash_including(region: 'us-east-1')).and_call_original
          subject.get_object('foo.txt')
        end
      end

      describe '#upload' do
        let(:file) { double(path: '/path/to/abc.txt', close: nil) }

        it 'uploads the file to s3' do
          expect_any_instance_of(Aws::S3::Object).to receive(:upload_file).with(file)

          subject.upload(file)
        end

        it 'returns the URI of the uploaded file' do
          allow_any_instance_of(Aws::S3::Object).to receive(:upload_file).with(file)
          expect(subject.upload(file)).to eq('s3://abc.txt')
        end
      end

      describe '#download' do
        let(:file) { double(:file) }
        let(:s3_object) { double(:s3_object) }

        before do
          allow(subject).to receive(:get_object).with('abc.txt').and_return(s3_object)
          allow(Tempfile).to receive(:new).with('abc.txt', encoding: Encoding::ASCII_8BIT).and_return(file)
        end

        it 'downloads the file from s3' do
          allow(s3_object).to receive(:get).with(hash_including(response_target: file)).and_return(file)
          allow(file).to receive(:set_encoding).with(Encoding::UTF_8)

          expect(subject.download('s3://abc.txt')).to eq(file)
        end

        context 'when s3 object does not exist' do
          it 'raises an EXEL::Error:JobTermination error' do
            allow(s3_object).to receive(:get).and_raise(Aws::S3::Errors::NoSuchKey.new(nil, 'key'))

            expect { subject.download('s3://abc.txt') }.to raise_error EXEL::Error::JobTermination
          end
        end
      end

      describe '.remote?' do
        it 'returns true for file:// URIs' do
          expect(S3Provider.remote?('s3://file')).to be_truthy
        end

        it 'returns false for anything else' do
          expect(S3Provider.remote?('file://path/to/file')).to be_falsey
          expect(S3Provider.remote?(1)).to be_falsey
          expect(S3Provider.remote?(nil)).to be_falsey
        end
      end
    end
  end
end
