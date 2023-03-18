module HashHelper
  def parse_temperature_wind_data(responses)
    # Parsing temperature and wind data from the response
    # Obtained from Visual Crossing API
    temperature_data = {}
    wind_data = {}
    responses.each do |city, response|
      temperature_data[city] = response['days'].map { |day| day['temp'] }
      wind_data[city] = response['days'].map { |day| day['windspeed'] }
    end
    return temperature_data, wind_data
  end
end
