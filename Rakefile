require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

# allow require of spec/spec_helper
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../'
$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the rspec_additions plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the rspec_additions plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Active Matchers'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = Gem::Specification.new do |s|
  s.name              = "active-matchers"
  s.version           = ActiveMatchers::Version::String
  s.summary           = "Helpful rspec matchers for testing validations and associations."
  s.description       = "Helpful rspec matchers for testing validations and associations."
  s.author            = "Pat Allan"
  s.email             = "pat@freelancing-gods.com"
  s.homepage          = "http://am.freelancing-gods.com"
  s.has_rdoc          = true
  s.rdoc_options     << "--title" << "Active Matchers - Model Matchers for RSpec" <<
                        "--line-numbers"
  s.rubyforge_project = "active-matchers"
  s.files             = FileList[
    "lib/**/*.rb",
    "LICENCE",
    "README"
  ]
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end
