require 'test_helper'
require 'test_helpers/capture'

require 'nsrr/models/file'

module ModelsTests
  class FileTest < Minitest::Test

    include TestHelpers::Capture

    def test_new_file
      f = Nsrr::Models::File.new({ 'file_name' => 'test.txt', 'checksum' => 'abc', 'is_file' => true, 'file_size' => 9, 'dataset' => 'wecare', 'file_path' => 'folder' })
      assert_equal 'test.txt',  f.name
      assert_equal 'abc',       f.web_checksum
      assert_equal true,        f.is_file
      assert_equal 9,           f.web_file_size
      # assert_equal 'wecare',    f.dataset_slug
      # assert_equal 'folder',    f.file_path
    end

  end
end
