import 'package:flutter/material.dart';
import 'package:skripsi_mobile/models/ui/menu.dart';
import 'package:skripsi_mobile/theme.dart';

class Card extends StatelessWidget {
  const Card(this.menu, {super.key, this.isRootNavigator = false});

  final Menu menu;
  final bool isRootNavigator;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: isRootNavigator)
          .push(MaterialPageRoute(builder: (_) => menu.to)),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                menu.img,
                colorBlendMode: BlendMode.color,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: AppColors.greenPrimary,
              child: Center(
                  child: Text(menu.title,
                      style: Fonts.semibold14
                          .copyWith(fontSize: 12, color: AppColors.white))),
            ),
          ],
        ),
      ),
    );
  }
}
