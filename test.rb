require 'treetop'
require 'alchemist'

Treetop.load "measurement"

parser = MeasurementParser.new
o = parser.parse('1 cup jfsidjf')
#puts o.inspect

o = parser.parse('1/2 cup')
puts o.inspect

