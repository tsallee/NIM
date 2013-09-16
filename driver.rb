#!/bin/ruby

puts "Welcome to Nim!"

puts "Board configuration \# 1:"
puts "X"
puts "XXX"
puts "XXXXX"
puts "XXXXXXX"

puts "\nBoard configuration \# 2:"
puts "XXXX"
puts "XXX"
puts "XXXXXXX"

boardConfig = 0
puts ""

while (boardConfig != 1 && boardConfig != 2)
	print "Select board configuration (1 or 2): "
	boardConfig = STDIN.gets.chomp.to_i
end

puts "1: Smart Computer Player"
puts "2: Dumb Computer Player"

computerPlayer = 0

while (computerPlayer != 1 && computerPlayer != 2)
	print "Select board configuration (1 or 2): "
	computerPlayer = STDIN.gets.chomp.to_i
end