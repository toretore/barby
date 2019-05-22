$:.push File.expand_path("../lib", __FILE__)
require "barby/version"

Gem::Specification.new do |s|
  s.name        = "barby"
  s.version     = Barby::VERSION::STRING
  s.platform    = Gem::Platform::RUBY
  s.summary     = "The Ruby barcode generator"
  s.email       = "toredarell@gmail.com"
  s.homepage    = "http://toretore.github.com/barby"
  s.description = "Barby creates barcodes."
  s.authors     = ['Tore Darell']

  s.rubyforge_project = "barby"

  s.extra_rdoc_files  = ["README.md"]

  s.files             = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'vendor/**/*', 'bin/*']
  #s.executables       = ['barby'] #WIP, doesn't really work that well
  s.require_paths     = ["lib"]

end
