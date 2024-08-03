import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/milestone/milestone.dart';
import 'package:skripsi_mobile/shared/appbar/main_appbar.dart';
import 'package:skripsi_mobile/utils/keys.dart';

class MilestoneNavigation extends StatefulWidget {
  const MilestoneNavigation({super.key});

  @override
  State<MilestoneNavigation> createState() => _MilestoneNavigationState();
}

class _MilestoneNavigationState extends State<MilestoneNavigation> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigatorKeys.milestoneKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              return Scaffold(
                body: switch (settings.name) { _ => const MilestoneScreen() },
              );
            });
      },
    );
  }
}
