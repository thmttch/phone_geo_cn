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
        ].each do |test, expected |
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
        ].each do |test, expected |
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
        ].each do | test, expected |
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
            # SMS spammer
            ['021 10655755', '10655755'],
        ].each do | test, expected |
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
        ].each do | test, expected |
            x = CnPhoneNumber.new test
            assert_equal :mobile, x.type, "failed on #{test}"
            assert_equal :china_unicom, x.provider, "failed on #{test}"
            assert_equal expected, x.number
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
            ['18321012693', '21012693'],
            ['13439500544', '9500544'],
        ].each do | test, expected |
            x = CnPhoneNumber.new test
            assert_equal :mobile, x.type, "failed on #{test}"
            assert_equal :china_mobile, x.provider, "failed on #{test}"
            assert_equal expected, x.number 
            assert x.is_valid?, "failed on #{test}"
        end
        [
            # short 1 digit
            ['1363650974', '36509747'],
        ].each do | test, expected |
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
        ].each do |test, expected |
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

    def test_to_canonical_s
        [ 
            ['(+8610)5992 7396', '1059927396'],
            ['10-59927396', '1059927396'],
            ['021 61711150', '2161711150'],
            ['021 51879217', '2151879217'],
            ['021 51863213', '2151863213'],
            [110, '110'],
            [119, '119'],
            [120, '120'],
            [122, '122'],
            [999, '999'],
            [114, '114'],
            [12117, '12117'],
            [12121, '12121'],
            ['13636509747', '13636509747'],
        ].each do |test, expected |
            x = CnPhoneNumber.new test
            assert_equal expected, x.to_canonical_s, "failed on #{test}"
        end
    end

    def test_to_pretty_s
        [ 
            ['(+8610)5992 7396', '10-59927396'],
            ['10-59927396', '10-59927396'],
            ['021 61711150', '21-61711150'],
            ['021 51879217', '21-51879217'],
            ['021 51863213', '21-51863213'],
            [110, '110'],
            [119, '119'],
            [120, '120'],
            [122, '122'],
            [999, '999'],
            [114, '114'],
            [12117, '12117'],
            [12121, '12121'],
            ['13636509747', '136-36509747'],
        ].each do |test, expected |
            x = CnPhoneNumber.new test
            assert_equal expected, x.to_pretty_s, "failed on #{test}"
        end
    end

    # TODO more than 1 leading zero should probably not validate.
    def test_leading_zeros
        [ 
            ['02161711150', '21-61711150'],
            ['002161711150', '21-61711150'],
            ['0002161711150', '21-61711150'],
        ].each do |test, expected |
            x = CnPhoneNumber.new test
            assert_equal expected, x.to_pretty_s, "failed on #{test}"
        end
    end

end
