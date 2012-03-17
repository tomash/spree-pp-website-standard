source 'http://rubygems.org'

group :test do
  gem 'ffaker'
  gem "fuubar"
end

group :development do
  gem "guard-rspec"
end

group :development, :test do
  gem "combustion"
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end

gemspec
