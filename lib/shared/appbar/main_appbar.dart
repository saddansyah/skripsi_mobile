import 'package:flutter/material.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/keys.dart';

AppBar mainAppBar({String title = 'home'}) {
  return AppBar(
    // automaticallyImplyLeading: false,
    toolbarHeight: 72,
    title: Text(title, style: Fonts.semibold16),
    actions: [
      Builder(builder: (context) {
        return Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(72)),
                  border: Border.all(color: Colors.amberAccent, width: 2)),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: AppColors.amber,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '12',
                    style: Fonts.bold16,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                ScaffoldKeys.drawerKey.currentState!.openEndDrawer();
              },
              child: Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(72)),
                ),
              ),
            ),
            SizedBox(width: 12)
          ],
        );
      })
    ],
    centerTitle: false,
  );
}
