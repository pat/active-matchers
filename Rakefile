require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'

$:.unshift File.join(File.dirname(__FILE__), 'lib')

require 'active-matchers'

GEM = "active-matchers"
GEM_VERSION = ActiveMatchers::Version::STRING
AUTHOR = "Pat Allan"
EMAIL = "pat@freelancing-gods.com"
HOMEPAGE = "http://am.freelancing-gods.com"
SUMMARY = "Helpful rspec matchers for testing validations and associations."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project = GEM
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.textile','LICENSE']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  s.add_dependency 'activerecord'
  
  s.require_path = 'lib'
  s.files = %w(README.textile LICENSE Rakefile init.rb) + Dir.glob("{lib,specs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end
