require_relative "./true_crime"


class Category

  attr_reader :documentaries, :name, :url

  @@all = []

  def initialize(hash=nil, name=nil)
    hash.each do |key, value|
      self.send("#{key}=", value)
    end
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

  def create_from_category_collection(array)
    array.each do |hash|
      category = self.new(hash)
      category.save
    end
  end

  def self.create(name)
    category = self.new(name)
    category.save
    category
  end

  def category.count

  end

end
