require 'rake'
require 'rake/gempackagetask'
require 'fileutils'
require 'rake'
require 'spec/rake/spectask'
include FileUtils

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
