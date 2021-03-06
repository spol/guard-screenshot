# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "guard-screenshot"
  spec.version       = "0.0.2"
  spec.authors       = ["Seb Pollard"]
  spec.email         = ["seb@spolster.co.uk"]
  spec.description   = %q{Renders an HTML file to a PNG on save.}
  spec.summary       = %q{Renders an HTML file to a PNG on save.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "phantomjs.rb"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
