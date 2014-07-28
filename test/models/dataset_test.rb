require 'test_helper'
require 'test_helpers/capture'

require 'nsrr/models/dataset'

module ModelsTests
  class DatasetTest < Minitest::Test

    include TestHelpers::Capture

    def test_new_dataset
      d = Dataset.new({ 'slug' => 'wecare', 'name' => 'We Care Clinical Trial' })
      assert_equal 'wecare', d.slug
      assert_equal 'We Care Clinical Trial', d.name
    end

  end
end
