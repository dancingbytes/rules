# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rules/version"

Gem::Specification.new do |s|

  s.name        = 'rules'
  s.version     = Rules::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['redfield', 'Tyralion']
  s.email       = ['info@dancingbytes.ru']
  s.homepage    = 'https://github.com/dancingbytes/rules'
  s.summary     = 'User rights control system for rails.'
  s.description = 'User rights control system for rails.'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.md']
  s.require_paths = ['lib']

  s.licenses = ['BSD']

  s.add_dependency 'railties', ['>= 3.0.0']

end