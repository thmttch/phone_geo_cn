require 'provinces.rb'
require 'providers.rb'

class CnPhoneNumber

    # TODO add type_number?
    attr_reader :raw_number, :number, :type, :type_number, 
        :provider, :provider_number, :city, :city_number, :area_code,
        :reason, :to_canonical_s

    # properties
    # is_valid | is_invalid
    # type => is_mobile | is_landline | is_magic
    # provider => :china_unicom, :china_telecom, :china_mobile, :china_sat, :unknown, :not_applicable
    # city => :beijing, :shanghai, ..., :unknown, :not_applicable
    # reason => :ok, :unknown_type, :invalid_length, :invalid_city_code

    def initialize(number)
        @raw_number = number
        @number = CnPhoneNumber.clean(number)
        # assume okay until shown otherwise
        @reason = :ok
        #puts "number = #{@number}"

        # TODO too short or too long

        # let's determine the basic type: landline, mobile, magic, or unknown
        # source: TODO
        if CnPhoneNumber.is_magic_number?(@number)
            @type = :magic
        # a very basic length check: at least 7 digits, assuming no area or provider code
        elsif @number.length >= 7
            if @number[0] == '1'
                # at this point, it's either: Beijing's city code, OR ...
                if @number[1] == '0'
                    @type = :landline
                # no known mobile providers have '19...'
                elsif @number[1] != '9'
                    @type = :mobile
                else
                    @type = :unknown
                end
            else
                @type = :landline
            end
        else
            @type = :unknown
            @reason = :unknown_type
        end
        #puts "type = #{@type}"

        if @type == :mobile
            # see if we can find a provider, and strip it from @number if found
            @provider = :unknown
            @provider_number = nil
            Providers.all.each_pair do | area_code, provider |
                # all mobile numbers must be of length 8 (minus the provider code)
                if @number[0, area_code.length] == area_code && @number.length - area_code.length == 8
                    @provider = provider
                    @provider_number = area_code
                    @number = @number[area_code.length, @number.length]
                    break
                end
            end
        elsif @type == :landline
            # try to find the city, and strip it from @number if found
            @city = :unknown
            @city_number = nil
            Provinces.all.each_pair do | area_code, city |
                #puts area_code, city, @number[0, area_code.length]
                # all landline numbers must be >= length 7 (minus the provider code)
                if @number[0, area_code.length] == area_code && @number.length - area_code.length >= 7
                    @city = city
                    @city_number = area_code
                    @number = @number[area_code.length, @number.length]
                    break
                end
            end
        else
            @provider = :unknown
            @provider_number = nil
            @city = :unknown
            @city_number = nil
        end

    end

    def is_valid?
        (@type == :magic) || (@type == :mobile && @provider != :unknown) || (@type == :landline && @city != :unknown)
    end

    # returns the full number, properly marked with area code
    # if the number is not valid, returns nil
    def to_canonical_s
        if self.is_valid?
            if @type == :magic
                "#{@number}"
            else
                "#{area_code}#{@number}"
            end
        end
    end

    # returns the full number, properly marked with area code, with pretty printing
    # if the number is not valid, returns nil
    def to_pretty_s
        if self.is_valid?
            if @type == :magic
                "#{@number}"
            else
                "#{area_code}-#{@number}"
            end
        end
    end

    def area_code
        if @type == :mobile
            @provider_number
        elsif @type == :landline
            @city_number
        elsif @type == :magic
            @magic
        end
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

    # standard numbers, for emergencies, government, etc
    # does NOT do a is_valid check
    # source: http://en.wikipedia.org/wiki/Telephone_numbers_in_China#Emergency_Numbers
    # source: http://en.wikipedia.org/wiki/Telephone_numbers_in_China#Others
    def self.is_magic_number?(number)
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

        magic[number]
    end

end
