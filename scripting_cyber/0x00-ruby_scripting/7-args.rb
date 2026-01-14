#!/usr/bin/env ruby

def print_arguments
  if ARGV.empty?
    puts "No arguments provided."
  else
    ARGV.each.with_index(1) do |arg, index|
      puts "#{index}. #{arg}"
    end
  end
end
