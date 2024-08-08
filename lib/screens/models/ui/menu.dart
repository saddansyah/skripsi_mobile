import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_list_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_screen.dart';
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
  Menu('Cari Tong Sampah', '-', const CollectScreen()),
  Menu('Data Tong Sampah', '-', const CollectScreen()),
];

List<Menu> collectMenu = [
  Menu('Input Sampah', '-', const CollectScreen()),
  Menu('Data Kumpul Sampah', '-', const CollectListScreen()),
];
