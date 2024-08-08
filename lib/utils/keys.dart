import 'package:flutter/material.dart';

class NavigatorKeys {
  static GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> milestoneKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> missionKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> learnKey = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> achievementKey = GlobalKey<NavigatorState>();

  static List<GlobalKey<NavigatorState>> getNavigatorKeys() {
    return [homeKey, milestoneKey, missionKey, learnKey, achievementKey];
  }
}

class ScaffoldKeys {
  static final GlobalKey<ScaffoldState> mainLayoutKey =
      GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
}
