# -*- ruby -*-
require 'rubygems'

gem 'hoe'
require 'hoe'
Hoe.plugin :debugging
Hoe.plugin :git
Hoe.plugin :gemspec
Hoe.plugin :bundler
Hoe.add_include_dirs '.'

HOE = Hoe.spec 'barby' do
  developer 'Felix Bellanger', 'felix.bellanger@gmail.com'
  developer 'Tore Darell', 'toredarell@gmail.com'

  self.readme_file  = ['README',    ENV['HLANG'], 'rdoc'].compact.join('.')
  self.history_file = ['CHANGELOG', ENV['HLANG'], 'rdoc'].compact.join('.')

  self.clean_globs += [
    'barby.gemspec',
    'lib/barby/barby.{bundle,jar,rb,so}'
  ]

  self.extra_dev_deps += [
    ["hoe-bundler",     ">= 1.1"],
    ["hoe-debugging",   ">= 1.0.3"],
    ["hoe-gemspec",     ">= 1.0"],
    ["hoe-git",         ">= 1.4"],
    ["minitest",        "~> 2.2.2"],
    ["rake",            ">= 0.9"],
    ["rake-compiler",   "~> 0.8.0"],
  ]

  self.spec_extras = { :required_ruby_version => '>= 1.9.2' }
  
  self.spec.licenses = ['MIT']

  self.testlib = :minitest
end
