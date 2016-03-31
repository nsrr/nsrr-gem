# frozen_string_literal: true

require 'test_helper'

# Tests to assure that nsrr gem is an application.
class NsrrTest < Minitest::Test
  def test_nsrr_application
    assert_kind_of Module, Nsrr
  end

  def test_nsrr_version
    assert_kind_of String, Nsrr::VERSION::STRING
  end
end
