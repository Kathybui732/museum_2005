class Museum
  attr_reader :name,
              :exhibits

  def initialize(name)
    @name = name
    @exhibits = []
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
end
