import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skripsi_mobile/controller/auth_controller.dart';
import 'package:skripsi_mobile/theme.dart';
import 'package:skripsi_mobile/utils/error_extension.dart';

class SignIn extends ConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    ref.listen<AsyncValue>(authControllerProvider, (_, state) {
      state.showSnackbarOnError(context);
    });

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 36),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBBBBBB), width: 1),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: AppColors.white,
            ),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Silakan Gabung Bersama!',
                  style: Fonts.semibold16.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.greenPrimary,
                      foregroundColor: AppColors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )),
                  onPressed: state.isLoading
                      ? null
                      : authController.signInWithGoogle,
                  child: Container(
                    alignment: Alignment.center,
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: state.isLoading
                          ? [CircularProgressIndicator(color: AppColors.white)]
                          : [
                              Icon(
                                Icons.login_rounded,
                                color: AppColors.white,
                                weight: 100,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Masuk',
                                style: Fonts.bold16,
                              ),
                            ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
