/* global List, TapBase */
{
  'use strict';

  class SortableList extends TapBase {
    start(el) {
      super.start(el);

      this.setupSortButtons();
      this.init();
      this.bindEvents();
    }

    init() {
      // using listjs
      this.list = new List(this.$el.attr('id'), this.config);
      this.orderList();
    }

    bindEvents() {
      this.list.on('searchComplete', this.handleSearchComplete.bind(this));
    }

    handleSearchComplete(list) {
      $.publish('list-search-complete', list);
    }

    setupSortButtons() {
      this.$el.find('.sort').each(function() {
        $(this).replaceWith($(this)[0].outerHTML.replace('span', 'button'));
      });
    }

    orderList() {
      const defaultOrder = this.$el.data('default-order');

      if (defaultOrder) {
        this.list.sort(defaultOrder.value, { order: defaultOrder.order });
      }
    }
  }

  window.GOVUKAdmin.Modules.SortableList = SortableList;
}
