import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/repositories/auth_repository.dart';
import 'package:skripsi_mobile/screens/auth/auth_controller.dart';
import 'package:skripsi_mobile/theme.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final authState = ref.read(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello User', style: Fonts.bold18),
                  SizedBox(height: 12),
                  session.when(
                      data: (data) => Text(data?.refreshToken ?? '',
                          style: Fonts.regular12),
                      loading: () => Text('...', style: Fonts.regular12),
                      error: (error, stackTrace) =>
                          Text('-', style: Fonts.regular12))
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    )),
                onPressed: () {
                  authState.isLoading ? null : authController.signOut();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded),
                    SizedBox(width: 6, height: 48),
                    Text('Keluar Akun',
                        style:
                            Fonts.semibold16.copyWith(color: AppColors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
