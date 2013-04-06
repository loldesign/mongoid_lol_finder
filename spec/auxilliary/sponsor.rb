class Sponsor
  include Mongoid::Document

  field :name

  embedded_in :fighter
end