module EXEL
  module S3
    describe S3Provider do
      describe '#get_object' do
        before do
          EXEL.configure do |config|
            config.aws = OpenStruct.new
            config.s3_bucket = 'bucket'
          end
        end

        it 'has the correct bucket and file names' do
          file_name = 'abc.txt'
          s3_obj = subject.get_object(file_name)
          expect(s3_obj.bucket_name).to eq('bucket')
          expect(s3_obj.key).to eq(file_name)
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
        it 'downloads the file from s3' do
          file = double(:file)
          s3_object = double(:s3_object)

          expect(subject).to receive(:get_object).with('abc.txt').and_return(s3_object)
          expect(Tempfile).to receive(:new).with('abc.txt', encoding: Encoding::ASCII_8BIT).and_return(file)
          expect(s3_object).to receive(:get).with(hash_including(response_target: file)).and_return(file)
          expect(file).to receive(:set_encoding).with(Encoding::UTF_8)

          expect(subject.download('s3://abc.txt')).to eq(file)
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
