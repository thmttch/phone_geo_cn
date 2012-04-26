require 'test/unit'
require 'phone_geo_cn'

class HolaTest < Test::Unit::TestCase
    def test_hello
        assert_equal "hello", PhoneGeoCn.hi
    end
end
