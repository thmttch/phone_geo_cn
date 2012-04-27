# source: http://en.wikipedia.org/wiki/Telephone_numbers_in_China#Mobile_phones
class Providers
    @@providers = {
        '130' => :china_unicom,
        '131' => :china_unicom,
        '132' => :china_unicom,
        '133' => :china_telecom,

        '1340' => :china_mobile,
        '1341' => :china_mobile,
        '1342' => :china_mobile,
        '1343' => :china_mobile,
        '1344' => :china_mobile,
        '1345' => :china_mobile,
        '1346' => :china_mobile,
        '1347' => :china_mobile,
        '1348' => :china_mobile,

        '149' => :china_sat,

        '135' => :china_mobile,
        '136' => :china_mobile,
        '137' => :china_mobile,
        '138' => :china_mobile,
        '139' => :china_mobile,

        '145' => :china_unicom,
        '147' => :china_mobile,

        '150' => :china_mobile,
        '151' => :china_mobile,
        '152' => :china_mobile,

        '153' => :china_telecom,

        '155' => :china_unicom,
        '156' => :china_unicom,

        '157' => :china_mobile,
        '158' => :china_mobile,
        '159' => :china_mobile,

        '180' => :china_telecom,

        '182' => :china_mobile,

        '185' => :china_unicom,
        '186' => :china_unicom,

        '187' => :china_mobile,
        '188' => :china_mobile,

        '189' => :china_telecom,
    }

    def self.providers
        @@providers
    end
end
