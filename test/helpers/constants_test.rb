# frozen_string_literal: true

require "test_helper"
require "test_helpers/capture"
require "nsrr/helpers/constants"

module HelpersTests
  class ConstantsTest < Minitest::Test

    include TestHelpers::Capture

    def test_site_constant
      assert_equal "https://sleepdata.org", Nsrr::WEBSITE
    end

  end
end
