enum WasteType {
  mixed('MIXED'),
  b3('B3'),
  organik('ORGANIK'),
  gunaUlang('GUNA_ULANG'),
  daurUlang('DAUR_ULANG'),
  residu('RESIDU');

  const WasteType(this.value);
  final String value;
}

enum ContainerType {
  depo('DEPO'),
  tong('TONG'),
  other('OTHER');

  const ContainerType(this.value);
  final String value;
}

enum QuestType {
  recycle("RECYCLE"),
  reuse("REUSE"),
  reduce("REDUCE"),
  other("OTHER");

  const QuestType(this.value);
  final String value;
}

enum Status {
  pending("PENDING"),
  accepted("ACCEPTED"),
  rejected("REJECTED");

  const Status(this.value);
  final String value;
}

enum Reporter {
  user("Pengguna"),
  anonim("Anonim");

  const Reporter(this.title);
  final String title;
}

// Dropdowns
abstract class DropdownData {
  String get title;
  String get query;
}

enum DropdownCollectSort implements DropdownData {
  oldest('Terlama', 'sortBy=created_at&order=asc'),
  newest('Terbaru', 'sortBy=created_at&order=desc'),
  idasc('ID (asc)', 'sortBy=id&order=asc'),
  iddesc('ID (desc)', 'sortBy=id&order=desc'),
  status('Status', 'sortBy=status&order=desc');

  const DropdownCollectSort(this.title, this.query);

  @override
  final String title;

  @override
  final String query;
}

enum DropdownContainerSort implements DropdownData {
  newest('Terbaru', 'sortBy=created_at&order=desc'),
  favoritest('Terfavorit', 'sortBy=rating&order=asc'),
  status('Status', 'sortBy=status&order=asc'),
  atoz('A-Z', 'sortBy=name&order=asc'),
  ztoa('Z-A', 'sortBy=name&order=desc');

  const DropdownContainerSort(this.title, this.query);

  @override
  final String title;

  @override
  final String query;
}

enum DropdownWasteType implements DropdownData {
  all('Semua', ''),
  mixed('Mixed', 'type=mixed'),
  b3('B3', 'type=b3'),
  organik('Organik', 'type=organik'),
  gunaUlang('Guna Ulang', 'type=guna_ulang'),
  daurUlang('Daur Ulang', 'type=daur_ulang'),
  residu('Residu', 'type=residu');

  const DropdownWasteType(this.title, this.query);

  @override
  final String title;

  @override
  final String query;
}

enum DropdownContainerType implements DropdownData {
  all('Semua', ''),
  depo('Depo', 'type=depo'),
  tong('Tong', 'type=tong'),
  other('Lainnya', 'type=other');

  const DropdownContainerType(this.title, this.query);

  @override
  final String title;

  @override
  final String query;
}

enum DropdownStatus implements DropdownData {
  all('Semua', ''),
  pending('Pending', 'status=pending'),
  accepted('Accepted', 'status=accepted'),
  rejected('Rejected', 'status=rejected');

  const DropdownStatus(this.title, this.query);

  @override
  final String title;

  @override
  final String query;
}

enum DropdownLearnCategory implements DropdownData {
  all('Semua', ''),
  reuse('Reuse', 'category=Reuse'),
  reduce('Reduce', 'category=Reduce'),
  recycle('Recycle', 'category=Recycle'),
  wasteSorting('Pemilahan', 'category=Pemilahan');

  const DropdownLearnCategory(this.title, this.query);

  @override
  final String title;

  @override
  final String query;
}

enum DropdownLearnSort implements DropdownData {
  newest('Terbaru', 'sortBy=created_at&order=desc'),
  oldest('Terlama', 'sortBy=created_at&order=asc'),
  atoz('A-Z', 'sortBy=title&order=asc'),
  ztoa('Z-A', 'sortBy=title&order=desc');

  const DropdownLearnSort(this.title, this.query);

  @override
  final String title;

  @override
  final String query;
}
