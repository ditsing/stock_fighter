require 'test_helper'

class StockFighterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::StockFighter::VERSION
  end
end
