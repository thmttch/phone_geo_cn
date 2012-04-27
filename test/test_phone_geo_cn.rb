require 'test/unit'
require 'phone_geo_cn.rb'

class CnPhoneNumberTest < Test::Unit::TestCase

    # check at least it never blows up, regardless of the input
    def test_initialize
        [ 
            [1, '1'],
            [123, '123'],
            ['(+8610)5992 7396', '1059927396'],
            ['(+8610) 5992 0000', '1059920000'],
            ['08610 5992 0000', '1059920000'],
            [nil, nil],
            ['', nil],
            ['     ', nil],
            ['a bunch of words with no digits', nil],
        ].each do |test, expected|
            CnPhoneNumber.new test
        end
    end

    def test_clean
        [ 
            [1, '1'],
            [123, '123'],
            ['(+8610)5992 7396', '1059927396'],
            ['(+8610) 5992 0000', '1059920000'],
            ['08610 5992 0000', '1059920000'],
        ].each do |test, expected|
            assert_equal expected, CnPhoneNumber.clean(test)
        end
    end

    # TODO break this up so that they're actual unit tests
    def test_numbers

        # landline, beijing
        [
            ['(+8610)5992 7396', '59927396'],
            ['(+8610) 5992 0000', '59920000'],
            ['08610 5992 0000', '59920000'],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            assert_equal :landline, x.type, "failed on #{test}"
            assert_equal 'Beijing', x.city
            assert_equal expected, x.number
            assert x.is_valid?, "failed on #{test}"
        end

        # landline, shanghai
        [
            ['021 61711150', '61711150'],
            ['021 51879217', '51879217'],
            ['021 51863213', '51863213'],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            assert_equal :landline, x.type, "failed on #{test}, expected #{expected}"
            assert_equal 'Shanghai', x.city
            assert_equal expected, x.number
            assert x.is_valid?, "failed on #{test}"
        end

        # mobile, china_unicom
        [
            ['18612345678', '12345678'],
            ['15692164005', '92164005'],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            assert_equal x.type, :mobile, "failed on #{test}"
            assert_equal x.provider, :china_unicom, "failed on #{test}"
            assert_equal x.number, expected
            assert x.is_valid?, "failed on #{test}"
        end
        [
            # all short 1 digit
            ['1861234567', ''],
            ['1569216400', ''],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            assert ! x.is_valid?, "failed on #{test}"
        end

        # mobile, china_mobile
        [
            ['13636509747', '36509747'],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            assert_equal x.type, :mobile, "failed on #{test}"
            assert_equal x.provider, :china_mobile, "failed on #{test}"
            assert_equal x.number, expected
            assert x.is_valid?, "failed on #{test}"
        end
        [
            # short 1 digit
            ['1363650974', '36509747'],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            assert ! x.is_valid?, "failed on #{test}"
        end

    end

    def test_magic_numbers
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
            x = CnPhoneNumber.new test

            # either :magic or :unknown, depending
            if expected
                assert_equal :magic, x.type, "failed on #{test}"
            else
                assert_equal :unknown, x.type
            end

            assert_equal expected, x.is_valid?, "failed on #{test}"
        end
    end

end
