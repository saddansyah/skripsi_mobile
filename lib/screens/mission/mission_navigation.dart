import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_screen.dart';
import 'package:skripsi_mobile/screens/mission/container/container_screen.dart';
import 'package:skripsi_mobile/screens/mission/mission_screen.dart';
import 'package:skripsi_mobile/utils/keys.dart';

class MissionNavigation extends StatefulWidget {
  const MissionNavigation({super.key});

  @override
  State<MissionNavigation> createState() => _MissionNavigationState();
}

class _MissionNavigationState extends State<MissionNavigation> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigatorKeys.missionKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              switch (settings.name) { _ => const MissionScreen() },
        );
      },
    );
  }
}
