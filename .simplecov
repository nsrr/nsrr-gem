# frozen_string_literal: true

SimpleCov.start do
  add_group "Libraries", "/lib/"
  add_filter "/test/"
end
