# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "actionpack"
  s.version = "1.4.0"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["David Heinemeier Hansson"]
  s.autorequire = "action_controller"
  s.cert_chain = nil
  s.date = "2005-01-25"
  s.description = "Eases web-request routing, handling, and response as a half-way front, half-way page controller. Implemented with specific emphasis on enabling easy unit/integration testing that doesn't require a browser."
  s.email = "david@loudthinking.com"
  s.homepage = "http://www.rubyonrails.org"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.requirements = ["none"]
  s.rubyforge_project = "actionpack"
  s.rubygems_version = "1.8.11"
  s.summary = "Web-flow and rendering framework putting the VC in MVC."

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
