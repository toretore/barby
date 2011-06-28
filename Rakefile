require 'rake'
require 'rake/gempackagetask'
require 'rake/testtask'
require 'fileutils'

include FileUtils

spec = eval(File.read('barby.gemspec'))

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = false
end

task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts "generated latest version"
end

Rake::TestTask.new do |t|
  t.libs = ['lib','test']
  t.test_files = Dir.glob("test/**/*_test.rb").sort
  t.verbose = true
end

desc "Build RDoc"
task :doc do
  system "rm -rf site/rdoc; rdoc -tBarby -xvendor -osite/rdoc -mREADME lib/**/* README"
end
