Dir["#{File.dirname(__FILE__)}/../../vendor/*/lib"].each do |d|
  $: << File.expand_path(d)
end
