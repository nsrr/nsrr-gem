require 'test_helper'
require 'test_helpers/capture'

module ApplicationTests
  class HelpTest < Minitest::Test

    include TestHelpers::Capture

    def test_help
      output, error = util_capture do
        Nsrr.launch ['help']
      end

      assert_match "The most common nsrr commands are:", output
      Nsrr::COMMANDS.keys.each do |key|
        assert_match /^  \[#{key}\]/, output
      end
    end

  end
end
