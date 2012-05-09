# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','ios-portal.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'ios-portal'
  s.version = IOSPortal::VERSION
  s.author = 'Nolan Borwn'
  s.email = 'nolanbrown@gmail.com'
  s.homepage = 'http://github.com/nolanbrown'
  s.platform = Gem::Platform::RUBY
  s.summary = 'CLI to view iOS Provisioning Profiles and Devices in Member Center'
# Add your other files here if you make them
  s.files = %w(
bin/ios-portal
lib/ios-portal.rb
lib/ios-portal/client.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','ios-portal.rdoc']
  s.rdoc_options << '--title' << 'iOS Portal' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'ios-portal'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_runtime_dependency('gli')
  s.add_runtime_dependency('mechanize')
  s.add_runtime_dependency('highline')
  s.add_runtime_dependency('terminal-table')
end
