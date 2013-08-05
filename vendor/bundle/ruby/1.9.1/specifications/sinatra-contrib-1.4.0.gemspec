# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sinatra-contrib"
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Konstantin Haase", "Gabriel Andretta", "Nicolas Sanguinetti", "Eliot Shepard", "Andrew Crump", "Matt Lyon", "undr"]
  s.date = "2013-04-07"
  s.description = "Collection of useful Sinatra extensions"
  s.email = ["konstantin.mailinglists@googlemail.com", "ohhgabriel@gmail.com", "contacto@nicolassanguinetti.info", "eshepard@slower.net", "andrew.crump@ieee.org", "matt@flowerpowered.com", "undr@yandex.ru"]
  s.homepage = "http://github.com/sinatra/sinatra-contrib"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Collection of useful Sinatra extensions"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.4.2"])
      s.add_runtime_dependency(%q<backports>, [">= 2.0"])
      s.add_runtime_dependency(%q<tilt>, ["~> 1.3"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0"])
      s.add_runtime_dependency(%q<rack-protection>, [">= 0"])
      s.add_runtime_dependency(%q<eventmachine>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<erubis>, [">= 0"])
      s.add_development_dependency(%q<slim>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, ["~> 1.4.2"])
      s.add_dependency(%q<backports>, [">= 2.0"])
      s.add_dependency(%q<tilt>, ["~> 1.3"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rack-protection>, [">= 0"])
      s.add_dependency(%q<eventmachine>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.3"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<erubis>, [">= 0"])
      s.add_dependency(%q<slim>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, ["~> 1.4.2"])
    s.add_dependency(%q<backports>, [">= 2.0"])
    s.add_dependency(%q<tilt>, ["~> 1.3"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rack-protection>, [">= 0"])
    s.add_dependency(%q<eventmachine>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.3"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<erubis>, [">= 0"])
    s.add_dependency(%q<slim>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
