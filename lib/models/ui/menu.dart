import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/mission/collect/add_collect_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_list_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/container_screen.dart';
import 'package:skripsi_mobile/screens/mission/map/map_screen.dart';
import 'package:skripsi_mobile/theme.dart';

class Menu {
  final String title;
  final String img;
  Color fallbackColor = AppColors.greenSecondary;
  final Widget to;

  Menu(this.title, this.img, this.to);
}

List<Menu> missionMenu = [
  Menu('Entri Sampah', 'assets/images/icon-kumpul-sampah.png', const CollectScreen()),
  Menu('Temuan Sampah', 'assets/images/icon-lapor-sampah.png', const CollectScreen()),
  Menu('Peta Depo/Tong', 'assets/images/icon-cari-sampah.png', const MapScreen()),
  Menu('Data Depo/Tong', 'assets/images/icon-data-depo.png', const ContainerScreen()),
];

List<Menu> collectMenu = [
  Menu('Entri Sampah', 'assets/images/icon-kumpul-sampah.png', const AddCollectScreen()),
  Menu('Data Kumpul Sampah', 'assets/images/icon-data-depo.png', const CollectListScreen()),
];
