# Weather Report

- [Project Description](#project-description)
- [Running Project](#running-project)
- [Implementation Overview](#implementation-overview)



# Project Description

Weather Report is a ruby program that gets the daily temperature and wind speed for the last
30 days and outputs on the console (stdout) the average and the median temperature for

that period for the following cities:
Copenhagen, Denmark
Lodz, Poland
Brussels, Belgium
Islamabad, Pakistan

# Running Project
- Ruby-Version: 2.7.3
- Run `bundle install`
- copy the content of `.env.sample` and create a new file as `.env` and paste the content in it.  
- `.env` may contain `VISUAL_CROSSING_ENPOINT`, `VISUAL_CROSSING_API_KEY` and `DAYS_COUNT` in it which represents the visual crossing api endpoint, visual crossing api key and default last days count for weather stats.
- Run the main file using the ruby command `ruby main.rb`

# Implementation Overview
`main.rb`
- The root/main file for running the `weather_stats` service.

`weather_stats_service.rb`
- The service that gets the weather report of last specified days and parse temperature/wind_speed and find average and median of it.
- It gets inherited from `application_service.rb` i.e ApplicationService class which has the implementation of *call* method.
- *call* method forwards the  *WeatherStatsService.call()* to *new/initialize* of calling class and invokes *call* method.
- The service logic starts with making the call to Visual Crossing api by taking the cities and days.
- It obtains and parses the temperature and wind speed data from the api response as they are also being sent as query parameter in api.
- Based on the obtained data it gets the average and median of temperature and wind speed of cities.


`errors.rb`
- The code has new class called `InvalidResponseException` that inherits from the standard `StandardError` class in Ruby.
- It is being used to display error or exception messages incase of any error from visual crossing api.
