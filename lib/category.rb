require_relative "./true_crime"


class Category

  attr_accessor :name
  attr_reader :documentaries

  @@all = []

  def initialize(name)
    @name = name
    @documentaries = []
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  def self.destroy_all
    self.all.clear
  end

  def self.create(name)
    category = self.new(name)
    category.save
    category
  end

  def category.count
    
  end

end
