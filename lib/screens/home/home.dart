import 'package:flutter/material.dart';
import 'package:skripsi_mobile/screens/auth/sign_in.dart';
import 'package:skripsi_mobile/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: AppColors.red),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Masih Bingung?',
                      style: Fonts.semibold16.copyWith(color: AppColors.white)),
                  TextButton(
                    style: TextButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.dark2.withOpacity(0.3),
                        foregroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(72)),
                        )),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home/detail');
                    },
                    child: Text('Mulai Milestone!',
                        style:
                            Fonts.semibold14.copyWith(color: AppColors.white)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
