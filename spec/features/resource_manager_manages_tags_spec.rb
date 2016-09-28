require 'rails_helper'

RSpec.feature 'Resource manager manages tags', js: true do
  scenario 'Viewing existing tags' do
    given_the_user_identifies_as_a_resource_manager do
      and_there_are_existing_tags
      when_they_visit_the_tags_page
      then_they_see_the_tags
    end
  end

  def given_the_user_identifies_as_a_resource_manager
    @user = create(:resource_manager)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def and_there_are_existing_tags
    @tag = create(:tag)
  end

  def when_they_visit_the_tags_page
    @page = Pages::ManageTags.new.tap(&:load)
  end

  def then_they_see_the_tags
    expect(@page).to have_tags(count: 1)
  end
end