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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files.delete("test/outputter/rmagick_outputter_test.rb")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = ["lib"]

  s.add_development_dependency "minitest",        "~> 5.11"
  s.add_development_dependency "bundler",         "~> 1.16"
  s.add_development_dependency "rake",            "~> 10.0"
  s.add_development_dependency "semacode-ruby19", "~> 0.7"
  s.add_development_dependency "rqrcode",         "~> 0.10"
  s.add_development_dependency "prawn",           "~> 2.2"
  s.add_development_dependency "cairo",           "~> 1.15"
end
