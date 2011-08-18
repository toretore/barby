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
  #s.executables       = ['barby'] #WIP, doesn't really work that well
  s.require_paths     = ["lib"]

  s.post_install_message = <<-EOS

*** NEW REQUIRE POLICY ***"
Barby no longer require all barcode symbologies by default. You'll have
to require the ones you need. For example, if you need EAN-13,
require 'barby/barcode/ean_13'; For a full list of symbologies and their
filenames, see README.
***

  EOS

end
