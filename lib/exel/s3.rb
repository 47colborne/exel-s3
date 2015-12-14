require 'exel/s3/version'
require_relative 's3/s3_provider'

module EXEL
  module S3
    EXEL.configure do |config|
      config.remote_provider = EXEL::S3::S3Provider
    end
  end
end
