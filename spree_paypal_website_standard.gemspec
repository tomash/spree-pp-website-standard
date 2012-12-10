# encoding: UTF-8
version = File.read(File.expand_path("../GEM_VERSION",__FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_paypal_website_standard'
  s.version     = version
  s.summary     = 'Spree extension for integration with PayPal Website Standard payment'
  s.description = 'Spree extension for integration with PayPal Website Standard payment'
  s.required_ruby_version = '>= 1.9.2'

  s.author            = 'Gregg Pollack, Sean Schofield, Tomasz Stachewicz, Buddhi DeSilva'
  s.email             = 'tomekrs@o2.pl'
  s.homepage          = 'http://github.com/tomash/spree-pp-website-standard'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 1.0.3'

  s.add_development_dependency 'capybara', '1.0.1'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.7'
  s.add_development_dependency 'sqlite3'
end
