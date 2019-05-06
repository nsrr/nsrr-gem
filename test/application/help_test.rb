# frozen_string_literal: true

require "test_helper"
require "test_helpers/capture"

module ApplicationTests
  # Test to assure that the help documentation displays correctly.
  class HelpTest < Minitest::Test
    include TestHelpers::Capture

    def test_help
      output, _error = util_capture do
        Nsrr.launch ["help"]
      end

      assert_match "The most common nsrr commands are:", output
      Nsrr::COMMANDS.keys.each do |key|
        assert_match(/^  \[#{key}\]/, output)
      end
    end
  end
end
