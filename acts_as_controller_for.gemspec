$:.unshift File.expand_path('..', __FILE__)
require 'lib/acts_as_controller_for/version'

Gem::Specification.new do |s|
  s.platform      = Gem::Platform::RUBY
  s.name          = 'acts_as_controller_for'
  s.version       = ActsAsControllerFor::Version::STRING
  
  s.summary       = 'Common rails controller implementation'
  s.description   = 'This gem is an attempt to identify a pattern of simple rails controllers for common implementations'
  
  s.authors       = ['Jay Hayes']
  s.email         = 'ur@iamvery.com'
  s.homepage      = 'https://github.com/iamvery/acts_as_controller_for'
  
  s.files         = Dir['README.md', 'LICENSE', 'lib/**/*.rb']
end