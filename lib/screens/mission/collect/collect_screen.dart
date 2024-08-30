import 'package:flutter/material.dart' hide Card;
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/shared/card/card.dart';
import 'package:skripsi_mobile/models/ui/menu.dart';
import 'package:skripsi_mobile/theme.dart';

class CollectScreen extends StatelessWidget {
  const CollectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        title: Row(
          children: [
            const SizedBox(width: 6),
            Text('Kumpul Sampah',
                style: Fonts.bold16.copyWith(color: AppColors.dark2)),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Flexible(
              child: GridView.builder(
                itemCount: collectMenu.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemBuilder: (m, i) =>
                    Card(collectMenu[i], isRootNavigator: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
