require 'test/unit'
require 'CnPhoneNumber'

class CnPhoneNumberTest < Test::Unit::TestCase

=begin
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
        ].each do |test, expected|
            #assert_equal expected, PhoneGeoCn.clean(test)
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
=end

    def test_valid_numbers

        # landline, beijing
        [
            ['(+8610)5992 7396', '1059927396'],
            ['(+8610) 5992 0000', '1059920000'],
            ['08610 5992 0000', '1059920000'],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            puts x.is_valid?
            puts x.type
            puts x.city
            #assert x.is_valid?, "failed on #{test}"
        end

        # mobile, unicom
        [
            ['18612345678', '1059927396'],
        ].each do | test, expected|
            x = CnPhoneNumber.new test
            puts x.is_valid?
            puts x.type
            puts x.city
            puts x.provider
            #assert x.is_valid?, "failed on #{test}"
        end

    end

end
