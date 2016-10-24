require 'rails_helper'

RSpec.feature 'Resource manager modifies appointments' do
  scenario 'Rescheduling an appointment', js: true do
    given_the_user_is_a_resource_manager do
      and_there_are_appointments_for_multiple_guiders
      travel_to @appointment.start_at do
        when_they_view_the_appointments
        then_they_see_appointments_for_multiple_guiders
        when_they_reschedule_an_appointment
        then_the_appointment_is_modified
      end
    end
  end

  def and_there_are_appointments_for_multiple_guiders
    @ben = create(:guider, name: 'Ben Lovell')
    @jan = create(:guider, name: 'Jan Schwifty')

    @appointment = create(:appointment, guider: @ben)
    @other_appointment = create(:appointment, guider: @jan)
  end

  def when_they_view_the_appointments
    @page = Pages::ResourceCalendar.new.tap(&:load)
    expect(@page).to be_displayed
  end

  def then_they_see_appointments_for_multiple_guiders
    @page.wait_for_guiders

    expect(@page).to have_guiders(count: 2)
  end

  def when_they_reschedule_an_appointment
    skip
  end

  def then_the_appointment_is_modified
    skip
  end
end
