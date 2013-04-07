require 'spec_helper'

describe Mongoid::LolFilter do
  describe '#filter' do
    let(:heavyweight)      { Division.create(name: 'Heavyweight') }
    let(:light_heavyweight){ Division.create(name: 'Light Heavyweight')}

    let!(:fighter_1){ Fighter.create(created_at: '2000-07-17', division: heavyweight) }
    let!(:fighter_2){ Fighter.create(created_at: '2000-06-17', division: light_heavyweight) }

    context 'filter by created_at' do
      it { Fighter.filter(created_at: ['01/01/2012', '01/11/2012']).should have(0).item }
      it { Fighter.filter(created_at: ['01/06/2000', '30/06/2000']).should have(1).item }
      it { Fighter.filter(created_at: ['01/06/2000', '30/07/2000']).should have(2).item }
      it { Fighter.filter(created_at: ['01/06/2000']).should have(2).item }
    end

    context 'filter by by_belongs_to' do
      it { Fighter.filter(belongs_to: {name: 'division', id: heavyweight.id}).should have(1).item }
      it { Fighter.filter(belongs_to: {name: 'division', id: light_heavyweight.id}).should have(1).item }

      it { Fighter.filter(belongs_to: {name: 'division', id: nil}).should have(2).item }
      it { Fighter.filter(belongs_to: {name: 'division', id: ''}).should have(2).item }

      it { Fighter.filter(belongs_to: {name: 'division', id: heavyweight.id}).should eq([fighter_1]) }
      it { Fighter.filter(belongs_to: {name: 'division', id: light_heavyweight.id}).should eq([fighter_2]) }
    end
  end
end