# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'range/bisect/version'

Gem::Specification.new do |spec|
  spec.name          = 'range-bisect'
  spec.version       = Range::Bisect::VERSION
  spec.authors       = ['Ryan Biesemeyer']
  spec.email         = ['ryan@yaauie.com']
  spec.description   = 'Bisect a range, finding elements that match the block'
  spec.summary       = 'Adds Range::Bisect, which can be used to ' +
                       'find by bisection'
  spec.homepage      = 'https://github.com/yaauie/range-bisect'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($RS)
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^spec\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
