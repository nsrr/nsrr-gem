require 'test_helper'
require 'test_helpers/capture'

module ApplicationTests
  class HelpTest < Minitest::Test

    include TestHelpers::Capture

    def test_console
      skip
      output, error = util_capture do
        Nsrr.launch ['console']
      end

      assert_match "Loading environment (Nsrr #{Nsrr::VERSION::STRING})\n", output
    end

  end
end
