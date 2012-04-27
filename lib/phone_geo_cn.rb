class PhoneGeoCn

    # is_valid is the main method; all others are helpers to help determine validity

    def self.hi
        'hello'
    end

    # always returns a string, with everything except digits stripped out
    # also removes any long-distance prefixes and country prefixes
    def self.clean(number)
        # remove all non-digits
        result = number.to_s.gsub(/[^0-9]/, "")
        # remove any long-distance prefixes
        result = result.gsub(/^0*/, "")
        # remove the country code
        result = result.gsub(/^86/, "")
        result
    end

    def self.is_valid_with_reason(number)
        cleaned = PhoneGeoCn.clean(number)

        # let's determine the basic class: landline, mobile, or magic

        # it's either landline, or...
        if PhoneGeoCn.is_mobile?(cleaned)

        # mobile
        elsif PhoneGeoCn.is_landline?(cleaned)
            return :is_landline
        # magic
        elsif PhoneGeoCn.is_magic_number?(cleaned)
            return :is_magic
        # unrecognized
        else
        end

        # all good!
        :is_valid
    end

    def self.is_valid?(number)
        PhoneGeoCn.is_valid_with_reason(number) == :is_valid
    end

    # if number is not valid, then it's also not mobile
    # the converse is also true: if it's mobile, it must be valid
    def self.is_mobile?(number)
        cleaned = PhoneGeoCn.clean(number)
        cleaned.length == 11 && cleaned[0] == '1'
    end

    def self.is_landline?(number)
        #! PhoneGeoCn.is_mobile?(number)
        cleaned = PhoneGeoCn.clean(number)
        cleaned.length == 7 || cleaned.length == 8
    end

    def self.provider(number)

    end

    # if number is not valid, returns nil
    def self.province_name(number)
        if PhoneGeoCn.is_invalid?(number)
            return nil
        end

        cleaned = PhoneGeoCn.clean(number)

        provinces = {
        }
        provinces.default = false

        provinces[cleaned]
    end

    # standard numbers, for emergencies, government, etc
    # does NOT do a is_valid check
    # source: http://en.wikipedia.org/wiki/Telephone_numbers_in_China#Emergency_Numbers
    # source: http://en.wikipedia.org/wiki/Telephone_numbers_in_China#Others
    def self.is_magic_number?(number)
        cleaned = PhoneGeoCn.clean(number)

        magic = {
            '110' => true,
            '119' => true,
            '120' => true,
            '122' => true,
            '999' => true,

            '114' => true,
            '12117' => true,
            '12121' => true,
        }
        magic.default = false

        magic[cleaned]
    end

end
