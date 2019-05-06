# frozen_string_literal: true

require "stringio"

module TestHelpers
  # Helps capture STDOUT and STDERR output during tests.
  module Capture
    def util_capture
      orig_stdout = $stdout.dup
      orig_stderr = $stderr.dup
      captured_stdout = StringIO.new
      captured_stderr = StringIO.new
      $stdout = captured_stdout
      $stderr = captured_stderr
      yield
      captured_stdout.rewind
      captured_stderr.rewind
      return captured_stdout.string, captured_stderr.string
    ensure
      $stdout = orig_stdout
      $stderr = orig_stderr
    end
  end
end
