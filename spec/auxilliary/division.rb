class Division
  include Mongoid::Document
  include Mongoid::LolFinder

  field :name

  find_for :name

  has_many :fighters
end