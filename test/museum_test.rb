require "minitest/autorun"
require "minitest/pride"
require "mocha/minitest"
require "./lib/museum"
require "./lib/patron"
require "./lib/exhibit"

class MuseumTest < MiniTest::Test

	def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})
    @patron_1 = Patron.new("Bob", 20)
    @patron_2 = Patron.new("Sally", 20)
    @patron_3 = Patron.new("Johnny", 5)
  end

	def test_it_exists
		assert_instance_of Museum, @dmns
	end

	def test_it_has_attributes
		assert_equal "Denver Museum of Nature and Science", @dmns.name
	end

  def test_it_starts_with_no_exhibits_until_added
    assert_equal [], @dmns.exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_it_can_recommend_exhibits_matching_patrons_interests
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("IMAX")
    assert_equal [@dead_sea_scrolls, @gems_and_minerals], @dmns.recommend_exhibits(@patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  def test_can_admit_patrons
    assert_equal [], @dmns.patrons
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_patrons_by
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons_by(@dead_sea_scrolls)
    assert_equal [@patron_1], @dmns.patrons_by(@gems_and_minerals)
    assert_equal [], @dmns.patrons_by(@imax)
  end

  def test_patrons_by_exhibit_interests
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    expected = {
      @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
      @gems_and_minerals => [@patron_1],
      @imax => []
    }
    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_ticket_lottery_contestants
    patron_1 = Patron.new("Bob", 0)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    assert_equal [patron_1, @patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
  end

  def test_draw_lottery_winner
    patron_1 = Patron.new("Bob", 0)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    @dmns.admit(patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)
    museum = mock("Museum")
    museum.stubs(:draw_lottery_winner).returns("Johnny")

    assert_equal "Johnny", museum.draw_lottery_winner(@dead_sea_scrolls)
    assert_nil nil, museum.draw_lottery_winner(@gems_and_minerals)
  end

  def test_announce_lottery_winner
    museum = mock("Museum")
    patron_1 = Patron.new("Bob", 0)
    museum.add_exhibit(@dead_sea_scrolls)
    museum.add_exhibit(@gems_and_minerals)
    museum.add_exhibit(@imax)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")
    museum.admit(patron_1)
    museum.admit(@patron_2)
    museum.admit(@patron_3)
    museum.stubs(:draw_lottery_winner).returns("Johnny")

    assert_equal "Johnny has won the IMAX edhibit lottery", museum.announce_lottery_winner(@imax)
    assert_equal "No winners for this lottery", museum.announce_lottery_winner(@gems_and_minerals)
  end

  def test_cannot_attend_if_not_in_price_range
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(tj)
    assert_equal 7, tj.spending_money
  end


end
