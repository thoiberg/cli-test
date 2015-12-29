require_relative 'lib/cli-test/version'

Gem::Specification.new do |s|
  s.name          = 'cli-test'
  s.version       = CliTest::VERSION
  s.license       = 'MIT'
  s.platform      = Gem::Platform::RUBY
  s.summary       = "gem to make testing command line scripts easier"
  s.description   = "A rack-test inspired gem that provides helper methods to make testing command line scripts easier"
  s.author        = 'Tim Hoiberg'
  s.email         = 'tim.hoiberg@gmail.com'
  s.require_paths = ['lib']
  s.files         = Dir['lib/**/*']
  s.homepage      = 'https://github.com/thoiberg/cli-test'

  s.add_development_dependency 'yard', '~> 0.8'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'pry', '~> 0.10'
end