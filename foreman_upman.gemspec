require File.expand_path('lib/foreman_upman/version', __dir__)
require 'date'

Gem::Specification.new do |s|
  s.name        = 'foreman_upman'
  s.version     = ForemanUpman::VERSION
  s.license     = 'GPL-3.0'
  s.date        = Date.today.to_s
  s.authors     = ['Tobias Ehrig']
  s.email       = ['tobias.ehrig@hermesworld.com']
  s.homepage    = 'https://gitlab.int.hes.de/hes/foreman/foreman_upman'
  s.summary     = 'Gives the foreman limited update capabilities for Debian / Ubuntu Systems'
  # also update locale/gemspec.rb
  s.description = 'Gives the foreman limited update capabilities for Debian / Ubuntu Systems'
  s.files = Dir['{app,config,db,lib,locale}/**/*'] + ['LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rubocop'
end
