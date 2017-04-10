# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','mtsk-client','version.rb'])

spec = Gem::Specification.new do |s|
  s.name = 'mtsk-client'
  s.version = MtskClient::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A description of your project'


  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'

  s.bindir = 'bin'
  s.executables << 'mtsk-client'

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','mtsk-client.rdoc']
  s.rdoc_options << '--title' << 'mtsk-client' << '--main' << 'README.rdoc' << '-ri'


  s.add_runtime_dependency('gli','2.16.0')
  s.add_runtime_dependency('nokogiri')
  s.add_runtime_dependency('gli')

  # s.add_development_dependency('capybara')
  s.add_development_dependency('rspec')
  s.add_development_dependency('webmock')

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
end
