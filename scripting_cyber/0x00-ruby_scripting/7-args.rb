#!/usr/bin/env ruby

def print_arguments
  if ARGV.empty?
    puts "No arguments provided."
  else
    count = 1
    ARGV.each do |arg|
      puts "#{count}. #{arg}"
      count += 1
    end
  end
end
