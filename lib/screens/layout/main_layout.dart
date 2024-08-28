import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/screens/achievement/achievement_navigation.dart';
import 'package:skripsi_mobile/screens/home/home_navigation.dart';
import 'package:skripsi_mobile/screens/learn/learn_navigation.dart';
import 'package:skripsi_mobile/screens/milestone/milestone_navigation.dart';
import 'package:skripsi_mobile/screens/mission/mission_navigation.dart';
import 'package:skripsi_mobile/shared/drawer/main_drawer.dart';
import 'package:skripsi_mobile/shared/pageview/keep_alive_pageview.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/keys.dart';

// Destination Classes -----

class Destination {
  Destination(this.index, this.title, this.icon);

  final int index;
  final String title;
  final IconData icon;
}

// Main Layout -----

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  final List<Destination> destinations = <Destination>[
    Destination(0, 'Beranda', Icons.home_filled),
    Destination(1, 'Milestone', Icons.stairs_rounded),
    Destination(2, 'Misi', Icons.track_changes_rounded),
    Destination(3, 'Belajar', Icons.lightbulb_rounded),
    Destination(4, 'Capaian', Icons.star_rounded),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(navigationPageProvider);

    return NavigatorPopHandler(
      onPop: () {
        final NavigatorState navigator =
            NavigatorKeys.getNavigatorKeys()[selectedIndex].currentState!;
        navigator.pop();
      },
      child: Scaffold(
        key: ScaffoldKeys.mainLayoutKey,
        endDrawer: const MainDrawer(),
        body: SafeArea(
          top: false,
          child: PageView(
            controller: pageController.instance,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            children: const [
              KeepAlivePageView(child: HomeNavigation()),
              MilestoneNavigation(),
              MissionNavigation(),
              LearnNavigation(),
              AchievementNavigation(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (index) {
              if (selectedIndex == index) {
                NavigatorKeys.getNavigatorKeys()[index]
                    .currentState!
                    .popUntil((route) => route.isFirst);
              } else {
                ref.read(navigationPageProvider).animateTo(index);
              }
            },
            selectedIndex: selectedIndex,
            backgroundColor: AppColors.white,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: destinations.map((Destination destination) {
              return NavigationDestination(
                selectedIcon:
                    Icon(destination.icon, color: AppColors.greenPrimary),
                icon: Icon(destination.icon),
                label: destination.title,
              );
            }).toList()),
      ),
    );
  }
}

// Used for controllilng bottom navigation bar accross different navigations/screens

class NavigationPageController {
  final PageController instance;

  NavigationPageController(this.instance);

  void animateTo(int index) {
    instance.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}

final navigationPageProvider = Provider((ref) {
  return NavigationPageController(PageController());
});
