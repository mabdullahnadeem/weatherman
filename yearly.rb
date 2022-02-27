# frozen_string_literal: true

# yearly class has max, min, humidity var as hashes
class Yearly
  def initialize(max_temp, min_temp, humidity)
    @max_temp = Hash['max_temp' => max_temp, 'date' => date]
    @min_temp = Hash['min_temp' => min_temp, 'date' => date]
    @humidity = Hash['humidity' => humidity, 'date' => date]
  end
  attr_accessor :max_temp, :min_temp, :humidity, :date

  def print_object_according_to_date
    pp "Highest: #{@max_temp['max_temp']}C on #{@max_temp['date']}"
    pp "Lowest: #{@min_temp['min_temp']}C on #{@min_temp['date']}"
    pp "Humidity: #{@humidity['humidity']}% on #{@humidity['date']}"
  end
end
