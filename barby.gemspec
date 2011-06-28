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
  
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README"]

  s.files             = Dir['CHANGELOG', 'README', 'LICENSE', 'lib/**/*', 'vendor/**/*', 'bin/*']
  s.executables       = ['barby']
  s.require_paths     = ["lib"]
  
  s.add_dependency 'rqrcode', '~> 0.3.3'
end
