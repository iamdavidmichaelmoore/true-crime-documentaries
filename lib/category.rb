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

  def self.destroy_all
    self.all.clear
  end

  def save
    self.class.all << self
  end

  def self.create_category_from_collection(array)
    array.each do |hash|
      self.new(hash)
    end
  end

  def docs_count
    self.documentaries.count
  end
end
