$:.push File.expand_path("../lib", __FILE__)
require "barby/version"

Gem::Specification.new do |s|
  s.name                  = "barby"
  s.version               = Barby::VERSION::STRING
  s.platform              = Gem::Platform::RUBY
  s.summary               = "The Ruby barcode generator"
  s.email                 = "toredarell@gmail.com"
  s.homepage              = "http://toretore.github.com/barby"
  s.description           = "Barby creates barcodes."
  s.authors               = ['Tore Darell']
  s.required_ruby_version = '>= 3.1'
  s.licenses              = []

  s.extra_rdoc_files  = ["README.md"]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.test_files.delete("test/outputter/rmagick_outputter_test.rb")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths     = ["lib"]

  s.add_development_dependency "minitest",        "~> 5.25"
  s.add_development_dependency "bundler",         "~> 2.5"
  s.add_development_dependency "rake",            "~> 13.2"
  s.add_development_dependency "rqrcode",         "~> 2.2"
  s.add_development_dependency "prawn",           "~> 2.5"
  s.add_development_dependency "cairo",           "~> 1.17"
  s.add_development_dependency "dmtx",            "~> 0.2"
end
