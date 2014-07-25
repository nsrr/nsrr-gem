require 'test_helper'
require 'test_helpers/capture'

module ApplicationTests
  class VersionTest < Minitest::Test

    include TestHelpers::Capture

    def test_version
      output, error = util_capture do
        Nsrr.launch ['version']
      end

      assert_equal "Nsrr #{Nsrr::VERSION::STRING}\n", output
    end

  end
end
