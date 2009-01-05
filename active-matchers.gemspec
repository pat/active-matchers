Gem::Specification.new do |s|
  s.name = %q{active-matchers}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Pat Allan"]
  s.autorequire = %q{active-matchers}
  s.date = %q{2008-07-02}
  s.description = %q{Helpful rspec matchers for testing validations and associations.}
  s.email = %q{pat@freelancing-gods.com}
  s.extra_rdoc_files = ["README", "LICENSE"]
  s.files = ["README", "LICENSE", "Rakefile", "init.rb", "lib/active-matchers", "lib/active-matchers/assoc_reflection_methods.rb", "lib/active-matchers/matchers", "lib/active-matchers/matchers/association_matcher.rb", "lib/active-matchers/matchers/response_matchers.rb", "lib/active-matchers/matchers/validation_matcher.rb", "lib/active-matchers/matchers.rb", "lib/active-matchers.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://am.freelancing-gods.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Helpful rspec matchers for testing validations and associations.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
  end
end
