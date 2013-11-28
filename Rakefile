# -*- ruby -*-
require 'rubygems'

gem 'hoe'
require 'hoe'
Hoe.plugin :debugging
Hoe.plugin :git
Hoe.plugin :gemspec
Hoe.plugin :bundler
Hoe.add_include_dirs '.'

def java?
  /java/ === RUBY_PLATFORM
end

HOE = Hoe.spec 'barby' do
  developer 'Felix Bellanger', 'felix.bellanger@gmail.com'
  developer 'Tore Darell', 'toredarell@gmail.com'

  self.readme_file  = ['README',    ENV['HLANG'], 'rdoc'].compact.join('.')
  self.history_file = ['CHANGELOG', ENV['HLANG'], 'rdoc'].compact.join('.')

  self.extra_rdoc_files = FileList['*.rdoc','ext/pdf417/*.c']

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

  if java?
    self.spec_extras = { :platform => 'java' }
  else
    self.spec_extras = {
      :extensions => ["ext/pdf417/extconf.rb"],
      :required_ruby_version => '>= 1.9.2'
    }
  end

  self.testlib = :minitest
end
HOE.spec.licenses = ['MIT']

# ----------------------------------------

def add_file_to_gem relative_path
  target_path = File.join gem_build_path, relative_path
  target_dir = File.dirname(target_path)
  mkdir_p target_dir unless File.directory?(target_dir)
  rm_f target_path
  ln relative_path, target_path
  HOE.spec.files += [relative_path]
end

def gem_build_path
  File.join 'pkg', HOE.spec.full_name
end

if java?
  require "rake/javaextensiontask"
  Rake::JavaExtensionTask.new("barby", HOE.spec) do |ext|
    jruby_home = RbConfig::CONFIG['prefix']
    ext.ext_dir = 'ext/java'
    ext.lib_dir = 'lib/barby'
    jars = ["#{jruby_home}/lib/jruby.jar"] + FileList['lib/*.jar']
    ext.classpath = jars.map { |x| File.expand_path x }.join ':'
  end

  task gem_build_path => [:compile] do
    add_file_to_gem 'lib/barby/barby.jar'
  end
else
  require "rake/extensiontask"

  HOE.spec.files.reject! { |f| f =~ %r{\.(java|jar)$} }

  Rake::ExtensionTask.new("barby", HOE.spec) do |ext|
    ext.lib_dir = File.join(*['lib', 'barby', ENV['FAT_DIR']].compact)
    ext.config_options << ENV['EXTOPTS']
  end
end
