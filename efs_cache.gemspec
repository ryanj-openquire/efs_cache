
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "efs_cache/version"

Gem::Specification.new do |spec|
  spec.name          = "efs_cache"
  spec.version       = EfsCache::VERSION
  spec.authors       = ["Ryan Jansen"]
  spec.email         = ["ryanj@openquire.com"]

  spec.summary       = %q{Caches commonly accessed objects in S3 to EFS.}
  spec.description   = %q{Caches commonly accessed objects in S3 to EFS.}
  spec.homepage      = "https://github.com/Quire/efs_cache"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'aws-sdk-s3', '~> 1'
end
