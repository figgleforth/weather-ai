# frozen_string_literal: true
require "minitest/autorun"
require_relative "../test_helper"


class LocationHelperTest < Minitest::Test
	def setup
		@address = "1 Main St, Anytown, USA"
		@zipcode = "12345"
	end

	def test_zipcode_for_address_returns_zip_when_valid_geocoder_results
		geocoder_result = Minitest::Mock.new
		geocoder_result.expect :postal_code, @zipcode

		# #zipcode_for_address calls Geocoder.search
		Geocoder.stub :search, [geocoder_result] do
			zipcode = LocationHelper.zipcode_for_address @address
			assert_equal @zipcode, zipcode
			assert_kind_of String, zipcode
		end

		geocoder_result.verify
	end

	def test_zipcode_for_address_returns_nil_when_nil_address_provided
		assert_nil LocationHelper.zipcode_for_address nil
	end

	def test_zipcode_for_address_returns_nil_when_invalid_geocoder_results
		Geocoder.stub :search, [] do
			assert_nil LocationHelper.zipcode_for_address @address
		end
	end

	def test_zipcode_for_address_returns_nil_when_invalid_geocoder_search_query
		[nil, "", "`¡™£¢∞§¶•ªº–≠"].each do |address_input|
			Geocoder.stub :search, [] do
				assert_nil LocationHelper.zipcode_for_address address_input
			end
		end
	end

	def test_zipcode_for_address_returns_nil_when_geocoder_error_is_raised
		simulated_error_raise = Proc.new { raise Geocoder::Error }

		Geocoder.stub :search, simulated_error_raise do
			assert_nil LocationHelper.zipcode_for_address @address
		end
	end
end
