#!/usr/bin/env ruby

puts '3 favourite fruit:'
fruits = []
3.times do
  fruits << gets.chomp
end

puts fruits.join(',')