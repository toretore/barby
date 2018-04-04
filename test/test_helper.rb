require 'rubygems'
require 'barby'
require 'minitest/autorun'
require 'minitest/spec'

module Barby
  class TestCase < MiniTest::Spec

    include Barby

    private

    # So we can register outputter during an full test suite run.
    def load_outputter(outputter)
      @loaded_outputter ||= load "barby/outputter/#{outputter}_outputter.rb"
    rescue LoadError => e
      skip "#{outputter} not being installed properly"
    end

    def ruby_19_or_greater?
      RUBY_VERSION >= '1.9'
    end
  end
end
