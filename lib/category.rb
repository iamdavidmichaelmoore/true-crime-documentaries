require_relative "./true_crime"


class Category
  attr_accessor :name, :url, :documentaries

  @@all = []

  def initialize(hash)
    hash.each do |key, value|
      self.send("#{key}=", value)
    end
    @documentaries = []
    self.class.all << self
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

  def self.create_category_from_collection(array)
    array.each do |hash|
      self.new(hash)
    end
  end

  def self.create(name)
    category = self.new
    category.name = name
    category.save
    category
  end

  def self.find_or_create_by_name(name)
    self.find_by_name(name) || self.create(name)
  end

  def self.find_by_name(name)
    self.all.detect {|category| category.name == name}
  end

  def docs_count
    documentaries.count
  end
end
