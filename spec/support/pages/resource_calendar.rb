module Pages
  class ResourceCalendar < SitePrism::Page
    set_url '/resource_calendar'

    elements :guiders, '.fc-resource-cell'
    elements :appointments, '.fc-event'

    section :action_panel, '.t-action-panel' do
      element :save, '.t-save'
    end

    def reassign(appointment, guider:)
      with_script_context(appointment['id']) do
        "event.resourceId = #{guider.id};"
      end
    end

    def reschedule(appointment, hours:, minutes:)
      with_script_context(appointment['id']) do
        <<-JS
          event.start.hours(#{hours}).minutes(#{minutes});
          event.end.hours(#{hours + 1}).minutes(#{minutes});
        JS
      end
    end

    def find_holiday(holiday)
      page.evaluate_script(<<-JS).with_indifferent_access
        function() {
          return $('.js-calendar')
            .fullCalendar('clientEvents', #{holiday.id})[0];
        }();
      JS
    end

    private

    def with_script_context(id)
      page.driver.evaluate_script <<-JS
        function() {
          var calendar = $('.js-calendar');
          var event = calendar.fullCalendar('clientEvents', #{id})[0];

          #{yield}

          calendar.fullCalendar('updateEvent', event);
          calendar.data('loaded-module').handleEventChange(event, function() {});
        }();
      JS
    end
  end
end
