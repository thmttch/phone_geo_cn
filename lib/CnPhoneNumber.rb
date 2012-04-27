require 'provinces.rb'
require 'providers.rb'

class CnPhoneNumber

    # TODO add type_number?
    attr_reader :raw_number, :number, :type, :type_number, :provider, :provider_number, :city, :city_number

    # properties
    # is_valid | is_invalid
    # type => is_mobile | is_landline | is_magic
    # provider => :china_unicom, :china_telecom, :china_mobile, :china_sat, :unknown, :not_applicable
    # city => :beijing, :shanghai, ..., :unknown, :not_applicable
    # reason => :ok, :invalid_length, :invalid_city_code
    
    def initialize(number)
        @raw_number = number
        @number = CnPhoneNumber.clean(number)
        #puts "number = #{@number}"

        # TODO too short or too long

        # let's determine the basic type: landline, mobile, magic, or unknown
        # source: TODO
        if PhoneGeoCn.is_magic_number?(@number)
            @type = :magic
        elsif @number[0] == '1'
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
        #puts "type = #{@type}"

#        # landline, ...
#        if @number.length == 7 || @number.length == 8
#            @type = :mobile
#        # mobile, ...
#        elsif @number.length == 11 && @number[0] == '1'
#            @type = :landline
#        # magic, ...
#        elsif PhoneGeoCn.is_magic_number?(@number)
#            @type = :magic
#        # or unrecognized
#        else
#            @type = :unknown
#        end

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
                if @number[0, area_code.length] == area_code
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

end
