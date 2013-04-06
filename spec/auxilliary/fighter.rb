class Fighter
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::LolFinder
  include Mongoid::LolFilter

  field :name
  field :coach_name
  field :location
  field :equipaments, type: Hash , default: {}
  field :graduation , type: Array, default: []

  find_for :name, :coach_name, :division, :sponsors, :equipaments, :graduation

  belongs_to :division
  embeds_many :sponsors
end
