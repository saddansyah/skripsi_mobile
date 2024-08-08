import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/achievement/achievement_screen.dart';
import 'package:skripsi_mobile/shared/appbar/main_appbar.dart';
import 'package:skripsi_mobile/utils/keys.dart';

class AchievementNavigation extends StatefulWidget {
  const AchievementNavigation({super.key});

  @override
  State<AchievementNavigation> createState() => _AchievementNavigationState();
}

class _AchievementNavigationState extends State<AchievementNavigation> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigatorKeys.achievementKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: mainAppBar(title: 'Capaian'),
                body: switch (settings.name) { _ => const AchievementScreen() },
              );
            });
      },
    );
  }
}
