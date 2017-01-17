Gem::Specification.new do |s|
  s.name        = "kindle-highlights"
  s.version     = "1.0.2"
  s.summary     = "Kindle highlights"
  s.description = "Until there is a Kindle API, this will suffice."
  s.authors     = ["Eric Farkas"]
  s.email       = "eric@prudentiadigital.com"
  s.files       = ["lib/kindle_highlights.rb", "lib/kindle_highlights/client.rb"]
  s.homepage    = "https://github.com/speric/kindle-highlights"
  s.license     = "MIT"

  s.required_ruby_version = ">= 2.1.0"

  s.add_runtime_dependency "mechanize", ">= 2.7.2"
  s.add_development_dependency "rake"
  s.add_development_dependency "bundler",  "~> 1.3"
  s.add_development_dependency "minitest", "~> 5.0"
end
