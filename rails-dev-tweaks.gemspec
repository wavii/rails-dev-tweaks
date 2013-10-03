# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'rails_dev_tweaks/version'

Gem::Specification.new do |s|
  s.name        = 'rails-dev-tweaks'
  s.version     = RailsDevTweaks::VERSION
  s.authors     = ['Wavii, Inc.']
  s.email       = ['info@wavii.com']
  s.homepage    = 'http://wavii.com/'
  s.summary     = %q{A collection of tweaks to improve your Rails (3.1+) development experience.}
  s.description = %q{A collection of tweaks to improve your Rails (3.1+) development experience.}

  s.rubyforge_project = 'rails-dev-tweaks'

  s.files         = Dir['lib/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.require_paths = ['lib']

  s.add_runtime_dependency 'railties',   '>= 3.1'
  s.add_runtime_dependency 'actionpack', '>= 3.1'
end
