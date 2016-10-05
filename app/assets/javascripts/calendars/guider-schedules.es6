/* global moment,Calendar */
{
  'use strict';

  class GuiderSchedulesCalendar {
    constructor(el, config = {}) {
      this.displayMonths();
      this.displaySixWeekWindow();
      this.displaySchedules();
    }

    displaySixWeekWindow() {
      const today = moment();
      let nineMonthsFuture = moment(today).add(9, 'months'),
      sixWeeksFuture = moment(today).add(6, 'weeks'),
      millisecondsDiff = sixWeeksFuture.diff(nineMonthsFuture),
      percentageThroughPeriodStart = ((nineMonthsFuture - millisecondsDiff) / nineMonthsFuture) * 100;

      $('.guider-schedules__six-week-window').css({
        'margin-left': `${percentageThroughPeriodStart}%`,
        'width': '40%',
        'height': '140px'
      });
    }

    displayMonths() {
      const today = moment();
      this.threeMonthsAgo = moment(today).subtract(3, 'months'),
      this.nineMonthsFuture = moment(today).add(9, 'months');

      for (let currentMonth = this.threeMonthsAgo; currentMonth < this.nineMonthsFuture; currentMonth = moment(currentMonth).add(1, 'months')) {
        let shortMonth = currentMonth.format('MMM');
        $('.guider-schedules__months').append(`<div class="col-md-1 text-center guider-schedules__month">${shortMonth}</div>`);
      }
    }

    displaySchedules() {
      let schedules = [];

      $('[data-schedule-start]').each((scheduleIndex, schedule) => {
        schedules.push({
          'start': $(schedule).data('schedule-start'),
          'end': $(schedule).data('schedule-end')
        });
      });

      for (let schedule in schedules) {
        const yearInMilliseconds = 365 * 24 * 60 * 60 * 1000;

        let currentSchedule = schedules[schedule],
        scheduleLengthPercentage = 100,
        startDate = moment(currentSchedule.start),
        endDate = moment(currentSchedule.end),
        millisecondsDiff = this.nineMonthsFuture.diff(startDate),
        percentageThroughPeriodStart = ((yearInMilliseconds - millisecondsDiff) / yearInMilliseconds) * 100;

        if (millisecondsDiff >= 0) { // Can render on the current year view
          if (currentSchedule.end) {
            scheduleLengthPercentage = (endDate.diff(startDate) / yearInMilliseconds) * 100;
          }

          $('.guider-schedules__schedules')
          .append(`
            <div style="margin-left: ${percentageThroughPeriodStart}%; width: ${scheduleLengthPercentage}%" class="guider-schedules__schedule">
            </div>
          `);
        }
      }
    }
  }

  window.PWTAP = window.PWTAP || {};
  window.PWTAP.GuiderSchedulesCalendar = GuiderSchedulesCalendar;
}
