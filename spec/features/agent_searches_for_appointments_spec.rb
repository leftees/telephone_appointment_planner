require 'rails_helper'

RSpec.feature 'Agent searches for appointments' do
  scenario 'searches for nothing' do
    given_the_user_is_an_agent do
      and_appointments_exist
      when_they_search_for_nothing
      then_they_can_see_all_appointments
    end
  end

  scenario 'searches for a first name' do
    given_the_user_is_an_agent do
      and_appointments_exist
      when_they_search_for_a_first_name
      then_they_can_see_only_that_result
    end
  end

  scenario 'searches for date range' do
    given_the_user_is_an_agent do
      and_appointments_exist
      and_there_is_an_appointment_in_the_future
      when_they_search_for_a_date_range
      then_they_can_see_only_that_result
    end
  end

  def and_appointments_exist
    from = BusinessDays.from_now(3).at_midday

    @appointments = [
      create(:appointment, created_at: from + 2.seconds),
      create(:appointment, created_at: from + 1.second),
      create(:appointment, created_at: from)
    ]
  end

  def when_they_search_for_nothing
    @page = Pages::Search.new.tap(&:load)
  end

  def then_they_can_see_all_appointments
    expected = @appointments.map(&:id)
    actual = @page.results.map(&:id).map(&:text).map(&:to_i)
    expect(actual).to eq expected
  end

  def when_they_search_for_a_first_name
    @page = Pages::Search.new.tap(&:load)
    @expected_appointment = @appointments.second
    @page.q.set(@expected_appointment.first_name)
    @page.search.click
  end

  def then_they_can_see_only_that_result
    expect(@page).to have_results(count: 1)
    expect(@page.results.first.id.text.to_i).to eq @expected_appointment.id
  end

  def and_there_is_an_appointment_in_the_future
    @expected_appointment = create(
      :appointment,
      start_at: 20.days.from_now
    )
  end

  def when_they_search_for_a_date_range
    @page = Pages::Search.new.tap(&:load)
    start_at = I18n.l(18.days.from_now.to_date, format: :date_range_picker)
    end_at   = I18n.l(23.days.from_now.to_date, format: :date_range_picker)
    @page.date_range.set("#{start_at} - #{end_at}")
    @page.search.click
  end
end
