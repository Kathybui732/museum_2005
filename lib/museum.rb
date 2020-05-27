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



  # ticket_lottery_contestants returns an array of patrons that do not have enough money to see an exhibit, but are interested in that exhibit. The lottery winner is generated randomly based on the available contestants when draw_lottery_winner is called.
  # You will need to use a stub to test the announce_lottery_winner method in conjunction with the draw_lottery_winner method. JOY!
end
