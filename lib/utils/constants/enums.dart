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
