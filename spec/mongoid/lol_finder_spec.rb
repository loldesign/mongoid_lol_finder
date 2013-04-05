require 'spec_helper'

describe Mongoid::LolFinder do
  class Fighter
    include Mongoid::Document
    include Mongoid::LolFinder

    field :name
    field :coach_name
    field :location
    field :equipaments, type: Hash , default: {}
    field :graduation , type: Array, default: []

    find_for :name, :coach_name, :division, :sponsors, :equipaments, :graduation

    belongs_to :division
    embeds_many :sponsors
  end

  class Division
    include Mongoid::Document
    include Mongoid::LolFinder

    field :name

    find_for :name

    has_many :fighters
  end

  class Sponsor
    include Mongoid::Document

    field :name

    embedded_in :fighter
  end

  let!(:rocky) { Fighter.create( name: 'Rocky Balboa', 
                                 coach_name: 'Apollo Creed', 
                                 location: 'Las Vegas', 
                                 division: heavyweight, 
                                 equipaments: {
                                                "001" => {'description' => 'gloves'}, 
                                                "002" => {'description' => 'shoes'}, 
                                                "003" => {'description' => 'white-red-shorts'}
                                              }, 
                                 graduation: ['Tae Kwon Do', 'Boxe']
                               )}
  let!(:apollo){ Fighter.create( name: 'Apollo Creed', 
                                 location: 'Nevada', 
                                 division: light_heavyweight, 
                                 equipaments: {
                                                "001" => {'description' => 'gloves'}, 
                                                "002" => {'description' => 'shoes'}, 
                                                "004" => {'description' => 'american-flag-shorts'}
                                              }, 
                                 graduation: ['Judo', 'Boxe', 'Muay thai']
                                )}
  
  let(:heavyweight)      { Division.create(name: 'Heavyweight') }
  let(:light_heavyweight){ Division.create(name: 'Light Heavyweight')}
  
  let!(:petrorian){rocky.sponsors.create( name: 'Pretorian')}
  let!(:everlast){ apollo.sponsors.create(name: 'Everlast' )}

  describe '.find_for' do
    it { Fighter.should be_respond_to(:find_for) }
  end

  describe '.search' do
    context 'single search' do
      it { Fighter.search('').should have(2).item }
      it { Fighter.search('creed').should have(2).item }
      it { Fighter.search('rocky').should have(1).item }
      it { Fighter.search('balboa').should have(1).item }
      it { Fighter.search('nevada').should have(0).item }
      it { Fighter.search('Heavyweight').should have(1).item }
      it { Fighter.search('Pretorian').should have(1).item }
      it { Fighter.search('004').should have(1).item;}
    end
  end
end
