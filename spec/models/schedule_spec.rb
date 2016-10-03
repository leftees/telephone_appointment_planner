require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe 'validation' do
    context '#from' do
      it 'is valid with valid attributes' do
        expect(build(:schedule, from: 6.weeks.from_now.beginning_of_day)).to be_valid
      end

      it 'is not nil' do
        expect(build(:schedule, from: nil)).to_not be_valid
      end

      it 'is a minimum of six weeks in the future' do
        expect(build(:schedule, from: 1.day.ago.beginning_of_day)).to_not be_valid
        expect(build(:schedule, from: 5.weeks.from_now.beginning_of_day)).to_not be_valid
      end
    end
  end
end
