# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exel/s3/version'

Gem::Specification.new do |spec|
  spec.name          = 'exel-s3'
  spec.version       = EXEL::S3::VERSION
  spec.authors       = ['yroo']
  spec.email         = ['dev@yroo.com']
  spec.summary       = 'Makes EXEL use S3 to store files during context shifts.'
  spec.description   = 'Add-on to EXEL (https://github.com/47colborne/exel) that provides support for Amazon S3.'
  spec.homepage      = 'https://github.com/47colborne/exel-s3'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'exel', '~> 1'
  spec.add_dependency 'aws-sdk', '~> 2'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10'
  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'guard', '~> 2'
  spec.add_development_dependency 'guard-rspec', '~> 4'
  spec.add_development_dependency 'guard-rubocop', '~> 1'
  spec.add_development_dependency 'terminal-notifier', '~> 1'
  spec.add_development_dependency 'terminal-notifier-guard', '~> 1'
  spec.add_development_dependency 'rubocop', '~> 0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1'
  spec.add_development_dependency 'rubocop-rspec-focused', '~> 0'
end
