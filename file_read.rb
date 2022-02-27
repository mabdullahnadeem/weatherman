# frozen_string_literal: true

require 'colorize'
require_relative 'monthly'
require_relative 'yearly'

# months
module Months
  MONTHS = Hash['1' => 'Jan', '2' => 'Feb', '3' => 'Mar', '4' => 'Apr', '5' => 'May', '6' => 'Jun', '7' => 'Jul',
                '8' => 'Aug', '9' => 'Sep', '10' => 'Oct', '11' => 'Nov', '12' => 'Dec']
end

# takes input from args
class Weatherman
  include Months
  def initialize(type, year_month, path = '')
    @type = type
    @year = year_month.first
    @month = year_month.last.start_with?('0') ? year_month.last.split('0').last : year_month.last
    @path = path
  end

  def read_data_yearly_file(file_data, output_obj)
    if file_data[1].to_i > output_obj.max_temp['max_temp'].to_i
      output_obj.max_temp.delete('max_temp')
      output_obj.max_temp.delete('date')
      output_obj.max_temp['max_temp'] = file_data[1]
      output_obj.max_temp['date'] = file_data[0]
    end
    if file_data[3].to_i < output_obj.min_temp['min_temp'].to_i
      output_obj.min_temp.delete('min_temp')
      output_obj.min_temp.delete('date')
      output_obj.min_temp['min_temp'] = file_data[3]
      output_obj.min_temp['date'] = file_data[0]
    end
    if file_data[7].to_i > output_obj.humidity['humidity'].to_i
      output_obj.humidity.delete('humidity')
      output_obj.humidity.delete('date')
      output_obj.humidity['humidity'] = file_data[7]
      output_obj.humidity['date'] = file_data[0]
    end
    output_obj
  end

  def read_data_monthly_file(file_data, monthly_output)
    monthly_output.max_avg = file_data[2] if file_data[2].to_i > monthly_output.max_avg.to_i
    monthly_output.min_avg = file_data[2] if file_data[2].to_i < monthly_output.min_avg.to_i
    monthly_output.humidity_avg = file_data[8] if file_data[8].to_i > monthly_output.humidity_avg.to_i
    monthly_output
  end

  def read_data_monthly_colorize(file_data, index)
    max_temp_day = file_data[1].to_i
    min_temp_day = file_data[3].to_i
    str = ''
    max_temp_day.times { str += '+' }
    puts "#{index}: #{str.colorize(:red)} #{max_temp_day}C"
    str = ''
    min_temp_day.times { str += '+' }
    puts "#{index}: #{str.colorize(:blue)} #{min_temp_day}C"
  end

  def open_file_through_e_flag(output_obj)
    Dir.glob("#{@path}/*") do |file_names|
      file = File.open(file_names, 'r+') if file_names.include?(@year)
      if file
        file_data = file.readlines.map(&:chomp)
        file_data.delete_at(0)
        file_data.each { |string_data| read_data_yearly_file(string_data.split(','), output_obj) }
        file.close
      end
    end
    output_obj.print_object_according_to_date
  end

  def open_file_through_a_flag(monthly_output)
    Dir.glob("#{@path}/*") do |file_names|
      file = File.open(file_names, 'r+') if file_names.include?(@year) && file_names.include?(Months::MONTHS[@month])
      if file
        file_data = file.readlines.map(&:chomp)
        file_data.delete_at(0)
        file_data.each { |string_data| read_data_monthly_file(string_data.split(','), monthly_output) }
        file.close
      end
    end
    monthly_output.print_object_according_to_avg
  end

  def open_file_through_c_flag
    Dir.glob("#{@path}/*") do |file_names|
      file = File.open(file_names, 'r+') if file_names.include?(@year) && file_names.include?(Months::MONTHS[@month])
      if file
        file_data = file.readlines.map(&:chomp)
        file_data.delete_at(0)
        file_data.each_with_index { |string_data, index| read_data_monthly_colorize(string_data.split(','), index + 1) }
        file.close
      end
    end
  end

  def read_file
    case @type
    when '-e'
      output_obj = Yearly.new(-999, 999, 0)
      open_file_through_e_flag(output_obj)
    when '-a'
      monthly_output = Monthly.new(-999, 999, 0)
      open_file_through_a_flag(monthly_output)
    when '-c'
      open_file_through_c_flag
    end
  end
end

argument_error = 'Unexpected Arguments Given'

begin
  raise argument_error unless ARGV[0] && ARGV[1] && ARGV[2]
rescue StandardError => e
  p e.message
end

weatherman = Weatherman.new(ARGV[0], ARGV[1].split('/'), ARGV[2])
weatherman.read_file
