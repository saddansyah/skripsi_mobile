// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class Input<T> {
  T value;
  String title;

  Input(this.value, this.title);
}

class InputCard<T> extends Input<T> {
  String description;
  String img;

  InputCard(
    super.value,
    super.title,
    this.description,
    this.img,
  );
}

final List<InputCard<ContainerType>> containerTypeInputCards = [
  InputCard(
    ContainerType.depo,
    'Depo',
    'Depo adalah tempat sampah sentral yang ada di setiap fakultas di UGM',
    'assets/svgs/container_icon.svg',
  ),
  InputCard(
    ContainerType.tong,
    'Tong',
    'Tong adalah tempat sampah kecil yang tersebar di kampus',
    'assets/svgs/container_icon.svg',
  ),
  InputCard(
    ContainerType.other,
    'Lainnya',
    'Apabila tidak masuk dua kategori yang lain, dapat dimasukkan ke Lainnya',
    'assets/svgs/container_icon.svg',
  ),
];

final List<InputCard<WasteType>> wasteTypeInputCards = [
  InputCard(
    WasteType.b3,
    'B3',
    'Contoh sampah B3: neon, film, baterai, kaset, disket, racun serangga, limbah elektronik, dll',
    'assets/svgs/tong-merah.svg',
  ),
  InputCard(
    WasteType.daurUlang,
    'Daur Ulang',
    'Contoh sampah Daur Ulang: kardus, karton makanan dan minuman, koran bekas, buku bekas, dll',
    'assets/svgs/tong-biru.svg',
  ),
  InputCard(
    WasteType.gunaUlang,
    'Guna Ulang',
    'Contoh sampah Guna Ulang: botol kaca, botol plastik, kaleng makanan dan minuman, dll',
    'assets/svgs/tong-kuning.svg',
  ),
  InputCard(
    WasteType.residu,
    'Residu',
    'Contoh sampah Residu: popok, plastik kemasan kopi, sterefoam, puntung rokok, dll',
    'assets/svgs/tong-abu.svg',
  ),
  InputCard(
    WasteType.organik,
    'Organik',
    'Contoh sampah Organik: sisa makanan, serasah, tulang, duri, daging, limbah mudah terurai lainnya',
    'assets/svgs/tong-hijau.svg',
  ),
  InputCard(
    WasteType.mixed,
    'Mixed',
    'Pilih Mixed sebagai opsi terakhir ya..',
    'assets/svgs/container_icon.svg',
  ),
];
