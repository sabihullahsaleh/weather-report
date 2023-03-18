module MathsHelper
  def get_average_median_data(weather_data)
    # common method that calculates average and median
    # stores them in hash with city as keys
    average_data = {}
    median_data = {}

    weather_data.each do |city, value|
      average_data[city] = average(value)
      median_data[city] = median(value)
    end
    return average_data, median_data
  end

  def average(value)
    # calculation of average from value array
    value.mean.round(2)
  end

  def median(value)
    # calculation of median from value array
    value.median.round(2)
  end
end
