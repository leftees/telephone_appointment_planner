{
  'use strict';

  class MultiCheckbox {
    constructor(el, config = {}) {
      this.$el = el;
      this.config = config;
      this.itemCheckboxes = this.$el.find('[data-multi-checkbox="item"]');
      this.allCheckbox = this.$el.find('[data-multi-checkbox="all"]');

      this.bindEvents();
    }

    bindEvents() {
      this.itemCheckboxes.on('change', this.handleItemChange.bind(this));
      this.allCheckbox.on('change', this.handleAllChange.bind(this));
    }

    handleItemChange(event) {
      const $el = $(event.currentTarget),
        checked = this.getCheckedStatus($el);

      this.addRemoveClass($el, checked);
      this.allCheckbox.prop('checked', this.areAllItemsChecked());
    }

    handleAllChange(event) {
      const $el = $(event.currentTarget),
        checked = this.getCheckedStatus($el);

      this.itemCheckboxes.prop('checked', checked);
      this.addRemoveClass(this.itemCheckboxes, checked);
    }

    getCheckedStatus($el) {
      return $el.prop('checked');
    }

    addRemoveClass($el, checked) {
      $el.parents('[data-multi-checkbox-group]')[checked ? 'addClass' : 'removeClass'](this.config.selectedClassName);
    }

    areAllItemsChecked() {
      return $.grep(this.itemCheckboxes, (el) => {
        return !this.getCheckedStatus($(el));
      }).length === 0;
    }
  }

  window.PWTAP = window.PWTAP || {};
  window.PWTAP.MultiCheckbox = MultiCheckbox;
}