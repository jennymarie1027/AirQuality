class HomeController < ApplicationController
  def index
    require 'net/http'
    require 'json'
    @url = "https://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json&zipCode=#{@zip_query = params[:zipcode].present? ? params[:zipcode] : "80521"}&distance=25&API_KEY=B3CDAE6C-4CC1-4D86-8A95-371B28332224"
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    # Check for empty return result
    if @output.empty?
      @final_output = 'Error'
    else 
      @final_output = @output[0]['AQI']
    end
    # determine the background color
    if @final_output == 'Error'
      @api_color = 'grey'
    elsif @final_output <= 50
      @api_color = 'green'
      @api_description = "Good"
    elsif @final_output >= 51 && @final_output <= 100
      @api_color = 'yellow'
      @api_description = "Moderate"
    elsif @final_output >= 101 && @final_output <= 150
      @api_color = 'orange'
      @api_description = "Not great"
    elsif @final_output >= 151 && @final_output <= 200
      @api_color = 'red'
      @api_description = "Unhealthy"
    elsif @final_output >= 201 && @final_output <= 300
      @api_color = 'purple'
      @api_description = "Very Unhealthy"
    elsif @final_output >= 301 && @final_output <= 500
      @api_color = 'maroon'
      @api_description = "Hazardous"
    end
  end

  def zipcode
    @zip_query = params[:zipcode]

    if params[:zipcode].blank?
      @zip_query = "Hey, you forgot to enter a zipcode!"
    elsif params[:zipcode].length != 5
      @zip_query = "Please enter a valid zip code"
    elsif !params[:zipcode].match?(/^\d{5}$/)
      @zip_query = 'Zip code must only contain numbers'
    else
      # run the api method
      index
    end
  end

end
