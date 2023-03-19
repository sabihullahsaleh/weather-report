require_relative 'application_service'
require_relative '../helpers/hash_helper'
require_relative '../helpers/maths_helper'
require_relative '../errors'
require 'net/http'
require 'uri'
require 'json'
require 'date'
require 'descriptive_statistics'


class WeatherStatsService < ApplicationService
  include HashHelper
  include MathsHelper

  DEFAULT_DAYS_COUNT = 30
  DEFAULT_CITIES = ['Brussels,Belgium', 'Islamabad,Pakistan', 'Copenhagen,Denmark', 'Lodz,Poland']

  def initialize
    @days_count = ENV['DAYS_COUNT']&.to_i || DEFAULT_DAYS_COUNT
    @endpoint = ENV['VISUAL_CROSSING_ENPOINT']
    @start_date = Date.today - @days_count
    @end_date = Date.today
    @unit_group = 'us'
    @visual_crossing_api_key=ENV['VISUAL_CROSSING_API_KEY']
  end

  def call
    get_weather_report
    print_report
  end

  private

  def complete_visual_crossing_endpoint(city)
    "#{@endpoint}/#{city}/#{@start_date}/#{@end_date}?unitGroup=us&elements=temp%2Cwindspeed&key=#{@visual_crossing_api_key}"
  end

  def get_weather_report
    urls = city_with_urls
    responses = generate_response_from_url(urls)
    raise Errors::InvalidResponseException, responses if responses.class == String
    temperature_data = {}
    wind_data = {}
    temperature_data, wind_data = parse_temperature_wind_data(responses)
    @average_temp_data, @median_temp_data = get_average_median_data(temperature_data)
    @average_wind_data, @median_wind_data = get_average_median_data(wind_data)
  end

  def city_with_urls
    # Loop through the cities and build the API URLs with the parameters
    DEFAULT_CITIES.map do |city|
      url = URI(complete_visual_crossing_endpoint(city))
      [city, url]
    end.to_h
  end

  def generate_response_from_url(urls)
    # Make GET requests to the API for each city and parse the JSON responses
    begin
      urls.map do |city, url|
        [city, JSON.parse(Net::HTTP.get(url))]
      end.to_h
    rescue => e
      "#{e.message}"
    end
  end

  def print_report
    # for printing required output
    puts "City\t\twind_avg\twind_median\ttemp_avg\ttemp_median"
    DEFAULT_CITIES.each do |city|
      puts "#{city}\t#{@average_wind_data[city]}\t#{@median_wind_data[city]}\t#{@average_temp_data[city]}\t#{@median_temp_data[city]}"
    end
  end
end
