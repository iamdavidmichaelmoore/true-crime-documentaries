require_relative "./true_crime"


class Category

  attr_reader :documentaries, :name, :url

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

  def create_from_collection(array)
    array.each do |hash|
      self.new(hash)
    end
  end

  def docs_count
    documentaries.count
  end
end
