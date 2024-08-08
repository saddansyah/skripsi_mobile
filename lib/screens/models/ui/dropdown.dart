class DropdownItem {
  String hint;
  List<DropdownMenuItem> menuItems;

  DropdownItem(this.hint, this.menuItems);
}

class DropdownMenuItem {
  String title;
  String value;

  DropdownMenuItem(this.title, this.value);
}

List<DropdownItem> dummyDropdownItems = [
  DropdownItem('Urut', [
    DropdownMenuItem('Semua', '12'),
    DropdownMenuItem('Guna Ulang', '21'),
    DropdownMenuItem('Daur Ulang', '333'),
  ]),
  DropdownItem('Jenis', [
    DropdownMenuItem('Terdekat', '11'),
    DropdownMenuItem('Terbaru', '33'),
    DropdownMenuItem('ID', '243'),
  ]),
  DropdownItem('Rate', [
    DropdownMenuItem('5', '17'),
    DropdownMenuItem('4', '36'),
    DropdownMenuItem('3', '29'),
  ]),
];
