# EXEL::S3

[![Gem Version](https://badge.fury.io/rb/exel-s3.svg)](https://badge.fury.io/rb/exel-s3)
[![Build Status](https://snap-ci.com/47colborne/exel-s3/branch/master/build_image)](https://snap-ci.com/47colborne/exel-s3/branch/master)

This gem implements a "remote provider" for [EXEL](https://github.com/47colborne/exel) using Amazon S3. The remote provider is used when an async command is executed and a context shift occurs. Its job is to move the context to a remote storage location when the async call is initiated, and retrieve it before the async block is executed.

Typically, this gem would be used in conjunction with an EXEL async provider, such as [exel-sidekiq](https://github.com/47colborne/exel-sidekiq). In this case, the context is serialized and uploaded to S3 from the machine making the async call, then downloaded by the Sidekiq worker before it executes the async block.

## Installation

Add this line to your application's Gemfile:

    gem 'exel-s3'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install exel-s3

## Usage

By requiring this gem, EXEL will automatically be configured to use S3 to upload and download the serialized context when an async command is executed.

The following configuration must be provided:

    EXEL.configure do |config|
        config.aws = OpenStruct.new(
            access_key_id: 'your AWS access key ID',
            secret_access_key: 'your AWS secret access key'
        )
      
        config.s3_bucket = 'the name of the bucket to use'
    end

## Contributing

1. Fork it ( https://github.com/47colborne/exel-s3/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
