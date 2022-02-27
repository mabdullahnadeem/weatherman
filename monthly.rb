# frozen_string_literal: true

# yearly class has max, min, humidity var as hashes
class Monthly
  def initialize(max_avg, min_avg, humidity_avg)
    @max_avg = max_avg
    @min_avg = min_avg
    @humidity_avg = humidity_avg
  end

  attr_accessor :max_avg, :min_avg, :humidity_avg

  def print_object_according_to_avg
    pp "Highest Average: #{@max_avg}C"
    pp "Lowest Average: #{@min_avg}C"
    pp "Average Humidity: #{@humidity_avg}%"
  end
end
