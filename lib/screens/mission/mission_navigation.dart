import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/mission/mission.dart';
import 'package:skripsi_mobile/shared/appbar/main_appbar.dart';
import 'package:skripsi_mobile/theme.dart';
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
            builder: (BuildContext context) {
              return Scaffold(
                appBar: mainAppBar(title: 'Misi'),
                body: switch (settings.name) { _ => const MissionScreen() },
              );
            });
      },
    );
  }
}
