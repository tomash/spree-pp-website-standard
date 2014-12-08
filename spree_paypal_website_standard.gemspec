# encoding: UTF-8
version = File.read(File.expand_path("../GEM_VERSION",__FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_paypal_website_standard'
  s.version     = version
  s.summary     = 'Spree extension for integration with PayPal Website Standard payment'
  s.description = 'Spree extension for integration with PayPal Website Standard payment'

  s.required_ruby_version     = '>= 2.1.0'
  s.required_rubygems_version = '>= 1.8.23'

  s.author            = 'Gregg Pollack, Sean Schofield, Tomasz Stachewicz, Buddhi DeSilva'
  s.email             = 'tomekrs@o2.pl'
  s.homepage          = 'http://github.com/tomash/spree-pp-website-standard'

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4.0'
end
