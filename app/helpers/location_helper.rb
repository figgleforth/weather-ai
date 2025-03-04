# frozen_string_literal: true
require "geocoder"

module LocationHelper
	CACHE_EXPIRATION = 30.minutes.freeze

	# Get the zipcode for a given address. Searches are cached for 30 minutes by the exact address string. No formatting is applied to the given address before querying Geocoder. See config/initializers/geocoder.rb for caching settings.
	# @return [string, nil] The zipcode for the address, or nil if not found.
	def self.zipcode_for_address address
		return nil unless address.present?

		if (data = Geocoder.search(address))
			data.first.postal_code # data is guaranteed to be an array, based on the docs
		else
			nil
		end
	rescue StandardError => e
		nil
	end
end
