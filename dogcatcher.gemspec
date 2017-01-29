# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dogcatcher/version'

Gem::Specification.new do |spec|
  spec.name          = 'dogcatcher'
  spec.version       = Dogcatcher::VERSION
  spec.authors       = ['Ben Vidulich']
  spec.email         = ['ben@vidulich.co.nz']

  spec.summary       = %q{Dogcatcher is a tool to catch exceptions in Ruby applications and send them to Datadog}
  spec.description   = %q{Dogcatcher is a tool to catch exceptions in Ruby applications and send them to Datadog}
  spec.homepage      = 'https://github.com/zl4bv/dogcatcher'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'activesupport', '>= 4', '< 6'
  spec.add_runtime_dependency 'dogapi', '~> 1.22'
  spec.add_runtime_dependency 'dogstatsd-ruby', '~> 1.6'
end
