import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/home/home.dart';
import 'package:skripsi_mobile/screens/home/home_test.dart';
import 'package:skripsi_mobile/shared/appbar/main_appbar.dart';
import 'package:skripsi_mobile/utils/keys.dart';

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({super.key});

  @override
  State<HomeNavigation> createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigatorKeys.homeKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: mainAppBar(title: 'Beranda'),
                body: switch (settings.name) {
                  '/home/detail' => const HomeTest(),
                  _ => const HomeScreen()
                },
              );
            });
      },
    );
  }
}
