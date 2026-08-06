window.osunyMigration.SelectAll = function (container) {
    console.log("[SelectAll] Init.")
    this.container = container;
    this.selectAllBtns = this.container.querySelectorAll('.js-select-all--select-button');
    this.unselectAllBtns = this.container.querySelectorAll('.js-select-all--unselect-button');
    this.checkboxes = this.container.querySelectorAll('.js-select-all--checkbox');
    this.initEvents();
}

window.osunyMigration.SelectAll.prototype.initEvents = function () {
    var i;
    for (i = 0; i < this.selectAllBtns.length; i += 1) {
        this.selectAllBtns[i].addEventListener('click', this.toggleAll.bind(this, true));
    }
    for (i = 0; i < this.unselectAllBtns.length; i += 1) {
        this.unselectAllBtns[i].addEventListener('click', this.toggleAll.bind(this, false));
    }
}

window.osunyMigration.SelectAll.prototype.toggleAll = function (checked) {
    var i;
    for (i = 0; i < this.checkboxes.length; i += 1) {
        this.checkboxes[i].checked = checked;
    }
}

window.addEventListener('DOMContentLoaded', function () {
    var containers = document.querySelectorAll('.js-select-all'),
        i;

    for (i = 0; i < containers.length; i += 1) {
        new window.osunyMigration.SelectAll(containers[i]);
    }
});
