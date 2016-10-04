/* global Calendar */
{
  'use strict';

  class GuiderSchedulesCalendar extends Calendar {
    constructor(el, config = {}) {
      const calendarConfig = {
        defaultView: 'timelineYear'
      };

      super(el, calendarConfig);
    }
  }
}
