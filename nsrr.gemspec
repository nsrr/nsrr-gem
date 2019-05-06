# frozen_string_literal: true

# Compiling the Gem
# gem build nsrr.gemspec
# gem install ./nsrr-x.x.x.gem --no-document --local
#
# gem push nsrr-x.x.x.gem
# gem list -r nsrr
# gem install nsrr

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nsrr/version"

Gem::Specification.new do |spec|
  spec.name          = "nsrr"
  spec.version       = Nsrr::VERSION::STRING
  spec.authors       = ["Remo Mueller"]
  spec.email         = ["remosm@gmail.com"]
  spec.summary       = "Download files easily from the NSRR website, https://sleepdata.org"
  spec.description   = "The official ruby gem to download files and datasets from the [NSRR](https://sleepdata.org)"
  spec.homepage      = "https://github.com/nsrr/nsrr-gem"

  spec.required_ruby_version = ">= 2.4.6"
  spec.required_rubygems_version = ">= 2.6.3"

  spec.license       = "MIT"

  spec.files         = Dir["{bin,lib}/**/*"] + ["CHANGELOG.md", "LICENSE", "Rakefile", "README.md", "nsrr.gemspec"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", ">= 1.3.0"
  spec.add_dependency "minitest"
  spec.add_dependency "rake"
end
