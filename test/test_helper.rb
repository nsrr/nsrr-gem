# frozen_string_literal: true

require "simplecov"
require "minitest/autorun"
require "minitest/pride"

require File.expand_path("../lib/nsrr", __dir__)

# Initialize the String class `@disable_colorization` instance variable
String.disable_colorization = false
