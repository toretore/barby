require 'rake'
require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new do |t|
  t.libs = ['lib','test']
  t.test_files = Dir.glob("test/**/*_test.rb").sort
  t.verbose = true
end

RDoc::Task.new do |rdoc|
  rdoc.main = "README"
  rdoc.rdoc_files.include("README", "lib")
  rdoc.rdoc_dir = 'doc'
end
