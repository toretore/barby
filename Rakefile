require 'rake'
require 'rake/gempackagetask'
require 'fileutils'
require 'rake'
require 'spec/rake/spectask'
include FileUtils

spec = Gem::Specification.new do |s|
  s.name = "barby"
  s.version = "0.3.2"
  s.author = "Tore Darell"
  s.email = "toredarell@gmail.com"
  s.homepage = "http://toretore.github.com/barby"
  s.platform = Gem::Platform::RUBY
  s.summary = "A pure-Ruby barcode generator"
  s.rubyforge_project = "barby"
  s.files = FileList["lib/**/*", "bin/*", "vendor/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "barby"
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = false
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts "generated latest version"
end

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
    t.libs << './lib'
    t.ruby_opts << '-rubygems'
    t.spec_files = FileList['spec/*.rb']
end

desc "Build RDoc"
task :doc do
  system "rm -rf site/rdoc; rdoc -tBarby -xvendor -osite/rdoc -mREADME lib/**/* README"
end
