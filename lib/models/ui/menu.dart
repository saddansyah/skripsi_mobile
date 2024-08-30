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
  Menu('Kumpul Sampah', '-', const CollectScreen()),
  Menu('Temuan Sampah', '-', const CollectScreen()),
  Menu('Cari Depo/Tong', '-', const MapScreen()),
  Menu('Data Depo/Tong', '-', const ContainerScreen()),
];

List<Menu> collectMenu = [
  Menu('Input Sampah', '-', const AddCollectScreen()),
  Menu('Data Kumpul Sampah', '-', const CollectListScreen()),
];
