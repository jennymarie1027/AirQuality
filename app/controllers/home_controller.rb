class HomeController < ApplicationController
  def index
    require 'net/http'
    require 'json'
    @url = 'https://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json&zipCode=80521&distance=25&API_KEY=B3CDAE6C-4CC1-4D86-8A95-371B28332224'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    # Check for empty return result
    if @output.empty?
      @final_output = 'Error'
    else 
      @final_output = @output[0]['AQI']
    end
  end
end
