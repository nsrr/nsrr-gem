# frozen_string_literal: true

require 'test_helper'
require 'test_helpers/capture'

module ApplicationTests
  # Test to assure that console loads correctly.
  class ConsoleTest < Minitest::Test
    include TestHelpers::Capture

    def test_console
      skip
      output, _error = util_capture do
        Nsrr.launch ['console']
      end
      assert_match "Loading environment (Nsrr #{Nsrr::VERSION::STRING})\n", output
    end
  end
end
