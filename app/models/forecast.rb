class Forecast
	attr_accessor :cached, :location_name,
	              :temperature, :feels_like, :minimum, :maximum,
	              :humidity, :cloud_coverage,
	              :sunrise, :sunset

	def formatted_sunrise
		sunrise&.strftime("%l:%M %p")
	end

	def formatted_sunset
		sunset&.strftime("%l:%M %p")
	end
end
