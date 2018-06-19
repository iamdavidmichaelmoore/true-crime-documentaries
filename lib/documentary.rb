require_relative "./true_crime"


class Documentary

  attr_accessor :title, :year, :category, :synopsis, :synopsis_url

  @@all = []

  def initialize(hash=nil)
    hash.each do |key, value|
      self.send("#{key}=", value)
    end
    self.class.all << self
  end

  def self.all
    @@all
  end

  def self.destroy_all
    self.all.clear
  end

  def add_doc_attributes(hash)

  end

  def documentary_count

  end

  def find_or_create_by_name(name)

  end

  def find_by_(name)
  end

  def category=(name)
  end


end
