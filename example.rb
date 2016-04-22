require_relative 'microtest'
require_relative 'microtest/autorun'

class CalculateThingsTest < MicroTest::Test
  def setup
    @four = 4
  end

  def hello_world_test
    assert_equal @four, 2 + 2
  end

  def bye_world_test
    assert_equal @four, 2 + 1
  end

  def hello_again_test
    assert_equal @four, 3 + 1
  end
end

class AssertThingsTest < MicroTest::Test
  def x_test
    assert true
  end
end
