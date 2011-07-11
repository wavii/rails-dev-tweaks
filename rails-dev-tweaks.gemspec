# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'rails-dev-tweaks/version'

Gem::Specification.new do |s|
  s.name        = 'rails-dev-tweaks'
  s.version     = RailsDevTweaks::VERSION
  s.authors     = ['Wavii, Inc.']
  s.email       = ['info@wavii.com']
  s.homepage    = 'http://wavii.com/'
  s.summary     = %q{Speed up your Rails (3.1+) development environment.}
  s.description = %q{A collection of tweaks and monkey patches to improve performance of Rails dev environments.}

  s.rubyforge_project = 'rails-dev-tweaks'

  s.files         = Dir['lib/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'rails', '~> 3.1.0.rc4'
end

