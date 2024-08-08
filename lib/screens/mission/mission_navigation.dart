import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/exception/not_found_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_detail_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_list_screen.dart';
import 'package:skripsi_mobile/screens/mission/collect/collect_screen.dart';
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
        if (settings.name!.contains('/:id')) {
          final id = settings.arguments as int;
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => switch (settings.name) {
                    '/mission/collect/get/:id' => CollectDetailScreen(id: id),
                    _ => const NotFoundScreen()
                  });
        } else {
          return MaterialPageRoute(
              settings: settings,
              builder: (context) => switch (settings.name) {
                    '/mission/collect' => const CollectScreen(),
                    // '/mission/collect/get' => const CollectListScreen(),
                    '/mission/report' => const CollectScreen(),
                    '/mission/find' => const CollectScreen(),
                    '/mission/container' => const CollectScreen(),
                    _ => const MissionScreen()
                  });
        }
      },
    );
  }
}
