# require "httparty"
require './app/poros/holiday'
require './app/services/holiday_services'

class HolidaySearch
  def holiday_information
      service.holiday.map do |data|
        # require 'pry';binding.pry
      Holiday.new(data)
    end
  end

  def service
    HolidayService.new
  end
end