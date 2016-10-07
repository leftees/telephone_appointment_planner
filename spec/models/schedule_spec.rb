require 'rails_helper'

RSpec.describe Schedule, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe 'validation' do
    context '#start_at' do
      it 'is unique per user' do
        same_time = Time.zone.now
        same_user = create(:guider)
        create(
          :schedule,
          user: same_user,
          start_at: same_time
        )

        schedule = build(
          :schedule,
          user: same_user,
          start_at: same_time
        )
        expect(schedule).to_not be_valid

        schedule.user = create(:guider)
        expect(schedule).to be_valid
      end

      context 'first schedule' do
        let(:user) do
          create(:user)
        end

        def build_schedule(start_at)
          build_stubbed(:schedule, user: user, start_at: start_at)
        end

        it 'can have any start_at date' do
          expect(build_schedule(Time.zone.now)).to be_valid
        end

        it 'is not nil' do
          expect(build_schedule(nil)).to_not be_valid
        end
      end

      context 'not first schedule' do
        let(:user) do
          user = create(:user)
          user.schedules << build(:schedule)
          user.reload
          user
        end

        def build_schedule(start_at)
          build_stubbed(:schedule, user: user, start_at: start_at)
        end

        it 'is valid with valid attributes' do
          expect(build_schedule(6.weeks.from_now.beginning_of_day)).to be_valid
        end

        it 'is not nil' do
          expect(build_schedule(nil)).to_not be_valid
        end

        it 'is a minimum of six weeks in the future' do
          expect(build_schedule(1.day.ago.beginning_of_day)).to_not be_valid
          expect(build_schedule(5.weeks.from_now.beginning_of_day)).to_not be_valid
        end
      end
    end
  end

  describe '#modifiable?' do
    context 'schedule starts less than six weeks from now' do
      it 'is false' do
        schedule = build_stubbed(:schedule, start_at: 5.weeks.from_now)
        expect(schedule).to_not be_modifiable
      end
    end

    context 'schedule starts more than six weeks from now' do
      it 'is true' do
        schedule = build_stubbed(:schedule, start_at: 7.weeks.from_now)
        expect(schedule).to be_modifiable
      end
    end
  end

  describe '#available_slots_with_guider_count' do
    it 'returns available slots with a guider count' do
      monday_fifth_of_december = Date.new(2022, 12, 5)
      monday_twelth_of_december = Date.new(2022, 12, 12)

      1.upto(3) do
        guider = create(:guider)

        schedule = build(:schedule, user: guider, start_at: monday_fifth_of_december)
        schedule.save!
        schedule.slots << build(
          :slot,
          day_of_week: 4,
          start_hour: 9,
          start_minute: 0,
          end_hour: 10,
          end_minute: 0
        )

        schedule = build(:schedule, user: guider, start_at: monday_twelth_of_december)
        schedule.save!
        schedule.slots << build(
          :slot,
          day_of_week: 2,
          start_hour: 9,
          start_minute: 0,
          end_hour: 10,
          end_minute: 0
        )
      end

      travel_to(monday_fifth_of_december) do
        UsableSlot.regenerate_for_six_weeks
      end

      result = Schedule.available_slots_with_guider_count(
        monday_fifth_of_december,
        monday_fifth_of_december + 20.days
      )
      expect(result).to include(
        guiders: 3,
        start: DateTime.new(2022, 12, 8, 9, 0, 0).in_time_zone,
        end: DateTime.new(2022, 12, 8, 10, 0, 0).in_time_zone
      )
      expect(result).to include(
        guiders: 3,
        start: DateTime.new(2022, 12, 13, 9, 0, 0).in_time_zone,
        end: DateTime.new(2022, 12, 13, 10, 0, 0).in_time_zone
      )
      expect(result).to include(
        guiders: 3,
        start: DateTime.new(2022, 12, 20, 9, 0, 0).in_time_zone,
        end: DateTime.new(2022, 12, 20, 10, 0, 0).in_time_zone
      )
    end

    it 'excludes slots that are obscured by an appointment' do
      monday_fifth_of_december = Date.new(2022, 12, 5)

      guider = create(:guider)
      create(
        :usable_slot,
        user: guider,
        start_at: DateTime.new(2022, 12, 9, 10, 30, 0).in_time_zone,
        end_at: DateTime.new(2022, 12, 9, 11, 30, 0).in_time_zone
      )

      result = Schedule.available_slots_with_guider_count(
        monday_fifth_of_december,
        monday_fifth_of_december + 20.days
      )
      expect(result).to_not be_empty

      create(
        :appointment,
        user: guider,
        start_at: DateTime.new(2022, 12, 9, 10, 30, 0).in_time_zone,
        end_at: DateTime.new(2022, 12, 9, 11, 30, 0).in_time_zone
      )
      result = Schedule.available_slots_with_guider_count(
        monday_fifth_of_december,
        monday_fifth_of_december + 20.days
      )
      expect(result).to be_empty
    end
  end
end
