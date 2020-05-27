require "minitest/autorun"
require "minitest/pride"
require "./lib/museum"
require "./lib/patron"
require "./lib/exhibit"

class MuseumTest < MiniTest::Test

	def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
	end

	def test_it_exists
		assert_instance_of Museum, @dmns
	end

	def test_it_has_attributes
		assert_equal "Denver Museum of Nature and Science", @dmns.name
	end

end