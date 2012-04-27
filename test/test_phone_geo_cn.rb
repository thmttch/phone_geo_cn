require 'test/unit'
require 'phone_geo_cn'

class HolaTest < Test::Unit::TestCase

=begin
    def test_hello
        assert_equal "hello", PhoneGeoCn.hi
    end

    def test_clean
        [ 
            [1, '1'],
            [123, '123'],
            ['(+8610)5992 7396', '1059927396'],
            ['(+8610) 5992 0000', '1059920000'],
            ['08610 5992 0000', '1059920000'],
        ].each do |test, expected|
            assert_equal expected, PhoneGeoCn.clean(test)
        end
    end

    def test_is_valid
        [ 
            #[1, false],
            #[123, false],
            #['(+8610)5992 7396', true],
            #['(+8610) 5992 0000', true],
        ].each do |test, expected|
            assert_equal expected, PhoneGeoCn.is_valid?(test)
        end
    end

    def test_is_mobile
        [ 
            [1, false],
            [123, false],
            [18616291234, true],
        ].each do |test, expected|
            assert_equal expected, PhoneGeoCn.is_mobile?(test), "failed on: #{test}"
        end
    end

    def test_is_landline
        [ 
            [1, false],
            [123, false],
            [18616291234, false],
        ].each do |test, expected|
            assert_equal expected, PhoneGeoCn.is_landline?(test), "failed on: #{test}"
        end
    end

    def test_province_name
        # invalid number returns nil
        assert_equal nil, PhoneGeoCn.province_name(123)
    end

    def test_is_magic_number
        [ 
            [110, true],
            [119, true],
            [120, true],
            [122, true],
            [999, true],
            [114, true],
            [12117, true],
            [12121, true],

            [1, false],
            [2, false],
            [3, false],
        ].each do |test, expected|
            assert_equal expected, PhoneGeoCn.is_magic_number?(test), "failed on: #{test}"
        end
    end

=end
end
