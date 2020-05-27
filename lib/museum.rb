class Museum
  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  # have to take theinstance object and add it instead of name to array
  def recommend_exhibits(patron)
    recommended = []
    @exhibits.each do |exhibit|
      recommended << exhibit if patron.interests.include?(exhibit.name)
    end
    recommended
  end

  def admit(patron)
    @patrons << patron
  end

  def patrons_by(exhibit)
    @patrons.select do |patron|
      patron.interests.include?(exhibit.name)
    end
  end

  def patrons_by_exhibit_interest
    pbei = Hash.new
    @exhibits.each do |exhibit|
      pbei[exhibit] = patrons_by(exhibit)
    end
    pbei
  end

  def not_enough_money?(patron, exhibit)
    patron.spending_money < exhibit.cost
  end

  def ticket_lottery_contestants(exhibit)
    @patrons.select do |patron|
      not_enough_money?(patron, exhibit)
    end
  end

  def draw_lottery_winner(exhibit)
    winner = ticket_lottery_contestants(exhibit).sample(1)
    winner.first
  end

  def announce_lottery_winner(exhibit)
    if draw_lottery_winner(exhibit) == nil
      "No winners for this lottery"
    else
      "#{draw_lottery_winner(exhibit).name} has won the #{exhibit.name} edhibit lottery"
    end
  end

  # ticket_lottery_contestants returns an array of patrons that do not have enough money to see an exhibit, but are interested in that exhibit. The lottery winner is generated randomly based on the available contestants when draw_lottery_winner is called.
  # You will need to use a stub to test the announce_lottery_winner method in conjunction with the draw_lottery_winner method. JOY!
end
