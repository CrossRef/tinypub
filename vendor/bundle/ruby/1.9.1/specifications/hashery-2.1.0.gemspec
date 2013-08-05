# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "hashery"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Trans", "Kirk Haines", "Robert Klemme", "Jan Molic", "George Moschovitis", "Jeena Paradies", "Erik Veenstra"]
  s.date = "2012-11-25"
  s.description = "The Hashery is a tight collection of Hash-like classes. Included among its many\nofferings are the auto-sorting Dictionary class, the efficient LRUHash, the\nflexible OpenHash and the convenient KeyHash. Nearly every class is a subclass\nof the CRUDHash which defines a CRUD model on top of Ruby's standard Hash\nmaking it a snap to subclass and augment to fit any specific use case."
  s.email = ["transfire@gmail.com"]
  s.extra_rdoc_files = ["LICENSE.txt", "NOTICE.txt", "HISTORY.rdoc", "DEMO.rdoc", "README.rdoc"]
  s.files = ["LICENSE.txt", "NOTICE.txt", "HISTORY.rdoc", "DEMO.rdoc", "README.rdoc"]
  s.homepage = "http://rubyworks.github.com/hashery"
  s.licenses = ["BSD-2-Clause"]
  s.require_paths = ["lib", "alt"]
  s.rubygems_version = "1.8.11"
  s.summary = "Facets-bread collection of Hash-like classes."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<detroit>, [">= 0"])
      s.add_development_dependency(%q<qed>, [">= 0"])
      s.add_development_dependency(%q<lemon>, [">= 0"])
    else
      s.add_dependency(%q<detroit>, [">= 0"])
      s.add_dependency(%q<qed>, [">= 0"])
      s.add_dependency(%q<lemon>, [">= 0"])
    end
  else
    s.add_dependency(%q<detroit>, [">= 0"])
    s.add_dependency(%q<qed>, [">= 0"])
    s.add_dependency(%q<lemon>, [">= 0"])
  end
end
