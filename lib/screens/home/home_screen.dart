import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/screens/layout/main_layout.dart';
import 'package:skripsi_mobile/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              // Card 1
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: AppColors.red),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Masih Bingung?',
                        style:
                            Fonts.semibold16.copyWith(color: AppColors.white)),
                    TextButton(
                      style: TextButton.styleFrom(
                          elevation: 0,
                          backgroundColor: AppColors.dark2.withOpacity(0.3),
                          foregroundColor: AppColors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(72)),
                          )),
                      onPressed: () {
                        ref.read(navigationPageProvider).animateTo(1);
                      },
                      child: Text('Mulai Milestone!',
                          style: Fonts.semibold14
                              .copyWith(color: AppColors.white)),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
