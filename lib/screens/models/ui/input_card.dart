import 'package:flutter_svg/flutter_svg.dart';
import 'package:skripsi_mobile/utils/constants/enums.dart';

class InputCard<T> {
  T value;
  String title;
  String description;
  String img;

  InputCard(this.value, this.title, this.description, this.img);
}

final List<InputCard<WasteType>> wasteTypeInputCards = [
  InputCard(
    WasteType.b3,
    'B3',
    'Contoh sampah B3: ...',
    'assets/svgs/container_icon.svg',
  ),
  InputCard(
    WasteType.daurUlang,
    'Daur Ulang',
    'Contoh sampah Daur Ulang: ...',
    'assets/svgs/container_icon.svg',
  ),
  InputCard(
    WasteType.gunaUlang,
    'Guna Ulang',
    'Contoh sampah Guna Ulang: ...',
    'assets/svgs/container_icon.svg',
  ),
  InputCard(
    WasteType.residu,
    'Residu',
    'Contoh sampah Residu: ...',
    'assets/svgs/container_icon.svg',
  ),
  InputCard(
    WasteType.organik,
    'Organik',
    'Contoh sampah Organik: ...',
    'assets/svgs/container_icon.svg',
  ),
  InputCard(
    WasteType.mixed,
    'Mixed',
    'Pilih Mixed sebagai opsi terakhir ya..',
    'assets/svgs/container_icon.svg',
  ),
];
