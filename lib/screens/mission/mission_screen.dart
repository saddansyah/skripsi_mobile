import 'package:flutter/material.dart' hide Card;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/screens/layout/main_layout.dart';
import 'package:skripsi_mobile/shared/appbar/styled_appbar.dart';
import 'package:skripsi_mobile/shared/card/card.dart';
import 'package:skripsi_mobile/models/ui/menu.dart';
import 'package:skripsi_mobile/theme.dart';

class MissionScreen extends ConsumerWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: StyledAppBar.main(title: 'Misi'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [AppColors.greenPrimary, Colors.green[800]!]),
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('#learn1',
                      style: Fonts.regular14.copyWith(color: AppColors.white)),
                  SizedBox(height: 6),
                  Text(
                    'Pemilahan Sampah 101',
                    style: Fonts.bold18
                        .copyWith(color: AppColors.white, fontSize: 21),
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        color: AppColors.dark1.withOpacity(0.1)),
                    child: Text(
                      'Sebelum kamu memulai misi Kumpul Sampah!, ada baiknya kamu belajar pemilahan sampah secara singkat dulu ya..',
                      style: Fonts.regular14.copyWith(color: AppColors.white),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.greenPrimary,
                        foregroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        )),
                    onPressed: () {
                      // Root navigate to learn (index 3)
                      ref.read(navigationPageProvider).animateTo(3);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lightbulb_rounded,
                            color: AppColors.white,
                            weight: 100,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Buka Menu Belajar',
                            style: Fonts.bold16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Flexible(
              child: GridView.builder(
                itemCount: missionMenu.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemBuilder: (m, i) => Card(
                  missionMenu[i],
                  isRootNavigator: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
