import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/learn/learn_screen.dart';
import 'package:skripsi_mobile/utils/keys.dart';

class LearnNavigation extends StatefulWidget {
  const LearnNavigation({super.key});

  @override
  State<LearnNavigation> createState() => _LearnNavigationState();
}

class _LearnNavigationState extends State<LearnNavigation> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigatorKeys.learnKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) =>
              switch (settings.name) { _ => const LearnScreen() },
        );
      },
    );
  }
}
