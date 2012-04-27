#!/usr/bin/env python

if __name__ == '__main__':
    f = open('provinces.csv', 'r')
    out = open('provinces.rb', 'w')

    out.write('provinces = {\n')

    for line in f:
        line = line.strip()

        city, province, area_code = line.split(',')
        out.write("\t'%s' => '%s',\n" % (area_code, city))

    out.write('}\n')

    f.close()
    out.close()
